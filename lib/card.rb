class Card
  attr_reader :value, :suit

  SUITS_ICONS = {
    spades: "\u2660".encode('utf-8'),
    clubs: "\u2663".encode('utf-8'),
    diamonds: "\u2666".encode('utf-8'),
    hearts: "\u2665".encode('utf-8')
  }.freeze

  HUMAN_VALUES = {
    1 => :ace,
    2 => 2,
    3 => 3,
    4 => 4,
    5 => 5,
    6 => 6,
    7 => 7,
    8 => 8,
    9 => 9,
    10 => 10,
    11 => :jack,
    12 => :queen,
    13 => :king
  }.freeze

  def initialize(value, suit)
    @value = value
    @suit = suit
  end

  def human_value
    HUMAN_VALUES[value]
  end

  def short_hand_value
    HUMAN_VALUES[value].is_a?(Symbol) ? HUMAN_VALUES[value][0].to_s.capitalize : HUMAN_VALUES[value]
  end

  def to_s
    "#{short_hand_value}#{SUITS_ICONS[suit]}"
  end

  def inspect
    "#{human_value} of #{@suit}"
  end
end
