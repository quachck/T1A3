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
      expect(punto.hand).to eq(game.deal_card(punto))
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

  describe '#round_over?' do
    it "returns true if only the punto's hand is 8 or 9" do
      punto.hand.push(Card.new(1, :spades), Card.new(8, :spades))
      banko.hand.push(Card.new(1, :spades), Card.new(8, :spades))
      expect(game.round_over?).to be(true)
    end
    it "returns true if only the banko's hand is 8 or 9" do
      punto.hand.push(Card.new(1, :spades), Card.new(10, :spades))
      banko.hand.push(Card.new(1, :spades), Card.new(8, :spades))
      expect(game.round_over?).to be(true)
    end
    it "returns true if both the punto's and banko's hand is 8 or 9" do
      punto.hand.push(Card.new(1, :spades), Card.new(7, :spades))
      banko.hand.push(Card.new(1, :spades), Card.new(8, :spades))
      expect(game.round_over?).to be(true)
    end
    it "returns false if neither the punto or banko's hand is 8 or 9" do
      punto.hand.push(Card.new(1, :spades), Card.new(13, :spades))
      punto.hand.push(Card.new(1, :spades), Card.new(13, :spades))
      expect(game.round_over?).to be(false)
    end
  end

  describe '#punto_rule' do
    it "draws a 3rd card if punto/banko's hand is <= 5'" do
      punto.hand.push(Card.new(1, :spades), Card.new(13, :spades))
      game.punto_rule(punto.hand)
      expect(punto.hand.length).to eq(3)
    end
    it "doesn't draw a 3rd card if punto/banko's hand is > 5'" do
      punto.hand.push(Card.new(1, :spades), Card.new(6, :spades))
      game.punto_rule(punto.hand)
      expect(punto.hand.length).to eq(2)
    end
  end

  describe '#banko_rule1' do
    context 'when punto does not draw a 3rd card' do
      it "banko draws a 3rd card if banko's hand is <= 5'" do
        punto.hand.push(Card.new(1, :spades), Card.new(13, :spades))
        banko.hand.push(Card.new(1, :spades), Card.new(3, :spades))
        game.banko_rule1
        expect(banko.hand.length).to eq(3)
      end
      it "banko doesn't draw a 3rd card if banko's hand is > 5'" do
        punto.hand.push(Card.new(1, :spades), Card.new(13, :spades))
        banko.hand.push(Card.new(1, :spades), Card.new(6, :spades))
        game.banko_rule1
        expect(banko.hand.length).to eq(2)
      end
    end

    context 'when punto does draw a 3rd card' do
      it 'banko draws a 3rd card when value < 3' do
        punto.hand.push(Card.new(1, :spades), Card.new(13, :spades), Card.new(13, :spades))
        banko.hand.push(Card.new(1, :spades), Card.new(1, :spades))
        game.banko_rule2
        expect(banko.hand.length).to eq(3)
      end
      it 'banko does not draw a 3rd card when value is 3 and punto 3rd card value is 8' do
        punto.hand.push(Card.new(1, :spades), Card.new(13, :spades), Card.new(8, :spades))
        banko.hand.push(Card.new(1, :spades), Card.new(2, :spades))
        game.banko_rule2
        expect(banko.hand.length).to eq(2)
      end
      it 'banko does not draw a 3rd card when value > 6' do
        punto.hand.push(Card.new(1, :spades), Card.new(13, :spades), Card.new(8, :spades))
        banko.hand.push(Card.new(1, :spades), Card.new(6, :spades))
        game.banko_rule2
        expect(banko.hand.length).to eq(2)
      end
      it 'banko does draw a 3rd card when value is 6 and punto 3rd card value is 7' do
        punto.hand.push(Card.new(1, :spades), Card.new(13, :spades), Card.new(6, :spades))
        banko.hand.push(Card.new(1, :spades), Card.new(5, :spades))
        game.banko_rule2
        expect(banko.hand.length).to eq(3)
      end
    end
  end
end
