require_relative 'player'
require_relative 'dealer'
require_relative 'deck'
require_relative 'baccarat_rules'
require_relative 'display'

class InsufficientFundError < StandardError; end
class NoFileError < StandardError; end
class ExistingFileError < StandardError; end

class Game
  include BaccaratRules
  include Display
  attr_accessor :deck, :punto, :banko, :player, :history

  def initialize
    @deck = Deck.new(8)
    @punto = Dealer.new
    @banko = Dealer.new
    @player = nil
    @history = []
  end

  # currency of the game 'ruby'
  def r
    "\u039B"
  end

  def start_menu
    case display_startup_options
    when 'Start new profile'
      begin
        set_player(Player.new(ask_name), true)
      rescue ExistingFileError
        ask_confirmation(Rainbow("Profile already exists, go back?").red) ? start_menu : retry
      end
    when 'Load existing profile'
      begin
        set_player(load_profile(Player.new(ask_name)), false)
      rescue NoFileError
        ask_confirmation(Rainbow("Profile doesn't exist, go back?").red) ? start_menu : retry
      end
    end
    game_menu
  end

  def game_menu
    case display_game_options
    when 'Bet'
      begin
        update_player_bet
      rescue InsufficientFundError => e
        puts Rainbow(e.message).red
        retry
      end
      play_round
      update_player_balance
      game_menu
    when 'Show balance'
      puts Rainbow("Your current balance is #{r}#{player.balance}").blue
      game_menu
    when 'Save progress and return to main menu'
      save_profile(player)
      start_menu
    when 'Save progress and quit'
      save_profile(player)
    end
  end

  # custom setter method for player
  def set_player(player, is_start)
    raise(ExistingFileError) if File.file?("save_files/#{player.name.downcase}.yaml") && is_start

    @player = player
  end

  # method to play 1 round
  def play_round
    deal_natural
    unless round_over?
      punto_rule(punto.hand)
      banko_rule1
      banko_rule2
    end
    deal_dummies([punto.hand, banko.hand])
    record_history
    draw_table(dealer_info(punto.hand, banko.hand, history), player_result_formatted, scores, player.balance, [player_bet, player_bet_amount])
    # puts "THERE ARE #{deck.cards.length} CARDS LEFT IN THE DECK"
  end

  # dealing methods
  def deal_card(dealer)
    dealer.hand << deck.draw
  end

  def deal_natural
    2.times do
      deal_card(punto)
      deal_card(banko)
    end
  end

  # deal dummies to help with GUI
  def deal_dummies(dealer_hands)
    dealer_hands.each do |hand|
      hand << Card.new('', '') if hand.length == 2
    end
  end

  def clear_hand
    unless punto.hand.empty?
      punto.hand.clear
      banko.hand.clear
    end
  end

  # game logic
  def calc_score(hand)
    hand.map(&:baccarat_value).sum < 10 ? hand.map(&:baccarat_value).sum : hand.map(&:baccarat_value).sum.to_s[1].to_i
  end

  def round_over?
    calc_score(punto.hand) >= 8 || calc_score(banko.hand) >= 8
  end

  def punto_rule(hand)
    hand << deck.draw if calc_score(hand) <= 5
  end

  def banko_rule1
    punto_rule(banko.hand) if punto.hand.length == 2
  end

  def banko_rule2
    banko_hand = calc_score(banko.hand)
    banko.hand << deck.draw if punto.hand.length == 3 && BANKER_RULES[banko_hand].include?(punto.hand[2].baccarat_value)
  end

  # game result
  def result
    if calc_score(punto.hand) > calc_score(banko.hand)
      :player
    elsif calc_score(punto.hand) < calc_score(banko.hand)
      :banker
    else
      :tie
    end
  end

  # compressing dealer info into an array to use as an argument to display it to the GUI
  def dealer_info(player_hand, banker_hand, history)
    dealer_info = []
    dealer_info.push(player_hand, banker_hand, history)
  end

  # betting functionality
  def player_bet_info
    player.bet[player.bet.length - 1]
  end

  def player_bet
    player.bet[player.bet.length - 1].keys[0]
  end

  def player_bet_amount
    player.bet[player.bet.length - 1][player_bet]
  end

  def player_result
    player_bet == result
  end

  # formatted player result to help with GUI
  def player_result_formatted
    if player_result
      "#{Rainbow("CONGRATS YOU WIN #{r}#{player_win_amount}!\n").green}#{Rainbow("NEW BALANCE: #{r}#{current_player.balance + player_win_amount}").gold}"
    else
      "#{Rainbow("SORRY YOU LOSE #{r}#{player_bet_amount}\n").red}#{Rainbow("NEW BALANCE: #{r}#{current_player.balance - player_bet_amount}").gold}"
    end
  end

  def player_win_amount
    player_bet_amount * ODDS[player_bet]
  end

  def sufficient_funds?(bet_amount)
    player.balance >= bet_amount
  end

  def update_player_bet
    bet_amount = ask_bet_amount.to_i
    raise(InsufficientFundError, "You only have #{player.balance}") unless sufficient_funds?(bet_amount)

    player.bet << { ask_what_bet => bet_amount }
  end

  # payout calculations
  def update_player_balance
    if player_result
      player.balance += player_win_amount
      player_bet_info[:win] = player_win_amount
    else
      player.balance -= player_bet_amount
      player_bet_info[:lose] = player_bet_amount
    end
  end

  # record result history
  def record_history
    history.unshift(result.to_s[0].upcase)
  end

  # save/load feature
  def load_profile(player)
    raise(NoFileError, "Profile doesn't exist") unless File.file?("save_files/#{player.name.downcase}.yaml")

    Player.from_yaml(File.open("save_files/#{player.name.downcase}.yaml", 'r'))
  end

  def save_profile(player)
    f = File.open("save_files/#{player.name.downcase}.yaml", 'w')
    f.puts player.to_yaml
    f.close
  end
end
