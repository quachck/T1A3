require './lib/game'

describe Game do
  subject(:game) { Game.new }
  subject(:punto) { game.punto }
  subject(:banko) { game.banko }
  subject(:deck) { game.deck }
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
        expect(punto).not_to be_nil
        expect(punto).to be_an_instance_of Dealer
      end
    end

    describe '#banko' do
      it 'returns a Dealer object' do
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

  describe '#deal_card' do
    it 'deals card to punto/banko' do
      game.deal_card(punto)
      expect(punto.hand.length).to eq(1)
      expect(deck.cards.length).to eq(415)
    end
  end

  describe '#deal_natural' do
    it 'deals 2 cards each to punto and banko' do
      game.deal_natural
      expect(punto.hand.length).to eq(2)
      expect(banko.hand.length).to eq(2)
      expect(deck.cards.length).to eq(412)
    end
  end

  describe '#calc_score' do
    it 'returns correct score with 2 cards' do
      expect(game.calc_score([Card.new(1, :spades), Card.new(8, :spades)])).to eq(9)
      expect(game.calc_score([Card.new(12, :spades), Card.new(7, :spades)])).to eq(7)
      expect(game.calc_score([Card.new(13, :spades), Card.new(13, :spades)])).to eq(0)
    end
    it 'returns correct score with 3 cards' do
      expect(game.calc_score([Card.new(1, :spades), Card.new(7, :spades), Card.new(1, :spades)])).to eq(9)
      expect(game.calc_score([Card.new(10, :spades), Card.new(11, :spades), Card.new(6, :spades)])).to eq(6)
      expect(game.calc_score([Card.new(13, :spades), Card.new(13, :spades), Card.new(13, :spades)])).to eq(0)
    end
  end
end
