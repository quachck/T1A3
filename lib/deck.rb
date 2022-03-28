require_relative 'card'

class Deck
  attr_reader :cards

  SUITS = %i[spades clubs diamonds hearts].freeze

  # build any number of decks, default set to 1
  def initialize(num_decks = 1)
    @cards = SUITS.map { |suit| build(suit, num_decks) }.flatten.shuffle
  end

  # build a set of 13 cards of a particular suit
  # map each value from 1-13 with that suit
  # can build any number of sets, default set to 1
  def build(suit, num_decks = 1)
    suited_cards = []
    num_decks.times { suited_cards << (1..13).map { |value| Card.new(value, suit) } }
    suited_cards
  end
end
