require_relative 'player'
require_relative 'dealer'
require_relative 'deck'
require_relative 'baccarat_rules'
require_relative 'display'

class InsufficientFundError < StandardError; end

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

  def start_menu
    case display_startup_options
    when 'Start new profile'
      self.player = Player.new(ask_name)
    when 'Load existing profile'
      # future feature
    end
    # game_menu
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
      pay_out
      game_menu
    when 'Show balance'
    when 'Save progress and quit'
    when 'Save progress and return to main menu'
    end
  end

  def deal_card(dealer)
    dealer.hand << deck.draw
  end

  def deal_natural
    2.times do
      deal_card(punto)
      deal_card(banko)
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

  def result
    if calc_score(punto.hand) > calc_score(banko.hand)
      :player
    elsif calc_score(punto.hand) < calc_score(banko.hand)
      :banker
    else
      :tie
    end
  end

  # betting functionality
  def sufficient_funds?(bet_amount)
    player.balance >= bet_amount
  end

  def update_player_bet
    bet_amount = ask_bet_amount.to_i
    raise(InsufficientFundError, "You only have #{player.balance}") unless sufficient_funds?(bet_amount)

    player.bet << { ask_what_bet => bet_amount }
  end
end

