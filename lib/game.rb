require_relative 'player'
require_relative 'dealer'
require_relative 'deck'

class Game
  attr_accessor :punto, :banko, :deck, :player, :history

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
end