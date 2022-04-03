require 'yaml'

class Player
  attr_reader :name
  attr_accessor :balance, :bet

  def initialize(name)
    @name = name
    @balance = 1000
    @bet = []
  end

  def to_yaml
    YAML.dump(self)
  end

  def self.from_yaml(yaml_file)
    YAML.load(yaml_file, permitted_classes: [Player])
  end
end
