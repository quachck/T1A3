require_relative 'player'
require_relative 'dealer'
require_relative 'deck'
require_relative 'baccarat_rules'

class Game
  include BaccaratRules
  attr_accessor :deck, :punto, :banko, :player, :history

  def initialize
    @deck = Deck.new(8)
    @punto = Dealer.new
    @banko = Dealer.new
    @player = nil
    @history = []
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
    punto_rule(banko.hand) if punto.hand.length < 3
  end

  def banko_rule2
    banko_hand = calc_score(banko.hand)
    if !banko_rule1 && BANKER_RULES[banko_hand].include?(punto.hand[2].baccarat_value)
      banko.hand << deck.draw
    end
  end
end