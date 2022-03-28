require './lib/game'

describe Game do
  subject(:game) { Game.new }
  it 'can be instantiated' do
    expect(game).not_to be_nil
    expect(game).to be_an_instance_of Game
  end

  describe '#initialize' do
    describe '#deck' do
      it 'returns 8 decks' do
        expect(game.deck).to be_an_instance_of Deck
        expect(game.deck.cards.length).to eq(416)
      end
    end

    describe '#punto' do
      it 'returns a Dealer object' do
        punto = Dealer.new
        expect(punto).not_to be_nil
        expect(punto).to be_an_instance_of Dealer
      end
    end

    describe '#banko' do
      it 'returns a Dealer object' do
        banko = Dealer.new
        expect(banko).not_to be_nil
        expect(banko).to be_an_instance_of Dealer
      end
    end

    describe '#player' do
      it 'returns a nil' do
        expect(game.player).to be_nil
      end
    end

    describe '#history' do
      it 'returns empty array' do
        expect(game.history).to eq([])
      end
    end
  end
end
