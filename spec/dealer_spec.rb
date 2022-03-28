require './lib/dealer'

describe Dealer do
  subject(:dealer) { Dealer.new }
  it 'can be instantiated' do
    expect(dealer).not_to be_nil
    expect(dealer).to be_an_instance_of Dealer
  end

  describe '#hand' do
    it 'returns empty array when instantiated' do
      expect(dealer.hand).to be_a(Array)
      expect(dealer.hand.length).to be(0)
    end
    it 'allows you to add elements to the hand' do
      expect(dealer.hand << 5).to eq([5])
      expect(dealer.hand.length).to be(1)
    end
  end
end