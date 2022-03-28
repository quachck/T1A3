require './lib/game'
# require './lib/deck'

deck = Deck.new(8)
deck.draw
puts deck.cards.length