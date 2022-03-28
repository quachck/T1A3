class Player
  attr_reader :name
  attr_accessor :balance, :bet

  def initialize(name)
    @name = name
    @balance = 1000.00
    @bet = []
  end
end
