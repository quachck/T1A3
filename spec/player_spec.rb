require './lib/player'

describe Player do
  subject(:player) { Player.new('David') }
  it 'can be instantiated' do
    expect(player).not_to be_nil
    expect(player).to be_an_instance_of Player
  end

  describe '#name' do
    it 'returns name' do
      expect(player.name).to eq('David')
    end
  end

  describe '#balance' do
    it 'allows you to update balance' do
      expect(player.balance += 500.00).to eq(1500.00)
    end
    it 'returns balance' do
      expect(player.balance).to eq(1000.00)
    end
  end

  describe '#bet' do
    it 'allows you to update bet' do
      expect(player.bet << { punto: 1000 }).to eq([{ punto: 1000 }])
    end
    it 'returns bet' do
      expect(player.bet).to eq([])
    end
  end
end