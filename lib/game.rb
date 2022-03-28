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
end