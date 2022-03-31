require './lib/game'

describe Game do
  subject(:game) { Game.new }
  subject(:punto) { game.punto }
  subject(:banko) { game.banko }
  subject(:deck) { game.deck }
  subject(:player) { game.player }

  it 'can be instantiated' do
    expect(game).not_to be_nil
    expect(game).to be_an_instance_of Game
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

  describe '#deck' do
    it 'returns 8 decks' do
      expect(game.deck).to be_an_instance_of Deck
      expect(game.deck.cards.length).to eq(416)
    end
  end

  describe '#player' do
    it 'returns nil' do
      expect(player).to be_nil
    end
  end

  describe '#history' do
    it 'returns empty array' do
      expect(game.history).to eq([])
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
      it "draws a 3rd card if banko's hand is <= 5'" do
        punto.hand.push(Card.new(1, :spades), Card.new(13, :spades))
        banko.hand.push(Card.new(1, :spades), Card.new(3, :spades))
        game.banko_rule1
        expect(banko.hand.length).to eq(3)
      end
      it "doesn't draw a 3rd card if banko's hand is > 5'" do
        punto.hand.push(Card.new(1, :spades), Card.new(13, :spades))
        banko.hand.push(Card.new(1, :spades), Card.new(6, :spades))
        game.banko_rule1
        expect(banko.hand.length).to eq(2)
      end
    end

    context 'when punto does draw a 3rd card' do
      it 'draws a 3rd card when value < 3' do
        punto.hand.push(Card.new(1, :spades), Card.new(13, :spades), Card.new(13, :spades))
        banko.hand.push(Card.new(1, :spades), Card.new(1, :spades))
        game.banko_rule2
        expect(banko.hand.length).to eq(3)
      end
      it 'does not draw a 3rd card when value is 3 and punto 3rd card value is 8' do
        punto.hand.push(Card.new(1, :spades), Card.new(13, :spades), Card.new(8, :spades))
        banko.hand.push(Card.new(1, :spades), Card.new(2, :spades))
        game.banko_rule2
        expect(banko.hand.length).to eq(2)
      end
      it 'does not draw a 3rd card when value > 6' do
        punto.hand.push(Card.new(1, :spades), Card.new(13, :spades), Card.new(8, :spades))
        banko.hand.push(Card.new(1, :spades), Card.new(6, :spades))
        game.banko_rule2
        expect(banko.hand.length).to eq(2)
      end
      it 'does draw a 3rd card when value is 6 and punto 3rd card value is 7' do
        punto.hand.push(Card.new(1, :spades), Card.new(13, :spades), Card.new(6, :spades))
        banko.hand.push(Card.new(1, :spades), Card.new(5, :spades))
        game.banko_rule2
        expect(banko.hand.length).to eq(3)
      end
    end
  end

  describe '#result' do
    it 'returns player when punto wins' do
      punto.hand.push(Card.new(1, :spades), Card.new(8, :spades))
      banko.hand.push(Card.new(1, :spades), Card.new(5, :spades))
      expect(game.result).to eq(:player)
    end
    it 'returns banker when banko wins' do
      punto.hand.push(Card.new(1, :spades), Card.new(1, :spades))
      banko.hand.push(Card.new(1, :spades), Card.new(8, :spades))
      expect(game.result).to eq(:banker)
    end
    it "returns player when it's a tie" do
      punto.hand.push(Card.new(1, :spades), Card.new(1, :spades))
      banko.hand.push(Card.new(2, :spades), Card.new(13, :spades))
      expect(game.result).to eq(:tie)
    end
  end

  describe '#update_player_bet' do
    it 'returns correctly stores bet info' do
      game.player = Player.new("David")
      allow(game).to receive(:ask_bet_amount).and_return('1000')
      allow(game).to receive(:ask_what_bet).and_return(:player)
      game.update_player_bet
      expect(player.bet).to eq([{ player: 1000 }])
    end
    it 'raises an error if insufficient funds' do
      game.player = Player.new("David")
      allow(game).to receive(:ask_bet_amount).and_return('1001')
      expect { game.update_player_bet }.to raise_error(InsufficientFundError)
    end
  end

  describe '#player_bet_info' do
    it 'returns player bet info' do
      game.player = Player.new("David")
      player.bet = [{ tie: 500, lose: 500 }, { banker: 1000, win: 2000 }]
      expect(game.player_bet_info).to eq({ banker: 1000, win: 2000 })
    end
  end

  describe '#player_bet' do
    it 'returns what the player bet on' do
      game.player = Player.new("David")
      player.bet = [{ tie: 500, lose: 500 }, { banker: 1000, win: 2000 }]
      expect(game.player_bet).to eq(:banker)
    end
  end

  describe '#player_bet_amount' do
    it 'returns how much the player bet' do
      game.player = Player.new("David")
      player.bet = [{ tie: 500, lose: 500 }, { banker: 1000, win: 2000 }]
      expect(game.player_bet_amount).to eq(1000)
    end
  end

  describe '#player_result' do
    it 'returns false if player lost' do
      punto.hand.push(Card.new(1, :spades), Card.new(8, :spades))
      banko.hand.push(Card.new(1, :spades), Card.new(5, :spades))
      game.player = Player.new("David")
      player.bet = [{ tie: 500, lose: 500 }, { banker: 1000, win: 2000 }]
      expect(game.player_result).to eq(false)
    end
    it 'returns true if player won' do
      punto.hand.push(Card.new(1, :spades), Card.new(8, :spades))
      banko.hand.push(Card.new(1, :spades), Card.new(5, :spades))
      game.player = Player.new("David")
      player.bet = [{ tie: 500, lose: 500 }, { player: 1000, win: 2000 }]
      expect(game.player_result).to eq(true)
    end
  end

end
