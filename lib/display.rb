require 'tty-prompt'
require 'rainbow'
require 'tty-link'

# Module to handle display
module Display
  STARTUP_OPTIONS = [
    'Start new profile',
    'Load existing profile'
  ].freeze
  GAME_OPTIONS = [
    'Bet',
    'Show balance',
    'Save progress and return to main menu',
    'Save progress and quit'
  ].freeze
  BET_OPTIONS = %i[player banker tie].freeze

  def display_startup_options
    TTY::Prompt.new.select(Rainbow("Welcome to The Ruby!").gold, STARTUP_OPTIONS)
  end

  def display_game_options(name)
    TTY::Prompt.new.select(Rainbow("What would you like to do, #{name}?").magenta, GAME_OPTIONS)
  end

  def ask_bet_amount
    TTY::Prompt.new.ask('How much would you like to bet?') do |q|
      q.validate(/\A\d+\Z/, 'Please enter a valid bet amount')
    end
  end

  def ask_what_bet
    TTY::Prompt.new.select('What would you like to bet on?', BET_OPTIONS)
  end

  def ask_name
    TTY::Prompt.new.ask('What is your name?') do |q|
      q.validate(/\A\D{3,15}\Z/, 'Please enter a valid name')
      q.modify(:capitalize)
    end
  end

  def ask_confirmation(msg)
    TTY::Prompt.new.yes?(msg)
  end

  def self.help_message
    puts "Enter ./run_main.sh to begin the app"
    puts "Enter ./run_main.sh -i to see more information"
    puts "Enter ./run_main.sh -r to see game rules"
  end

  def self.info_message
    puts "Welcome to The Ruby"
    puts "The Ruby only features baccarat at the moment"
    puts "You will begin with 1000 rubies"
    puts "You can only bet whole units of rubies"
    puts "You can leave and join at anytime without losing your progress"
    puts "The game is over if you lose all your rubies"
  end

  def self.rule_message
    puts "The Ruby offers the 'punto banco' variant of baccarat"
    puts TTY::Link.link_to("Refer to the wiki page for full details on the rules", "https://en.wikipedia.org/wiki/Baccarat")
  end
end
