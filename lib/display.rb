require 'tty-prompt'
require 'rainbow'

# Module to handle display
module Display
  STARTUP_OPTIONS = [
    'Start new profile',
    'Load existing profile'
  ].freeze
  GAME_OPTIONS = [
    'Bet',
    'Save progress and quit',
    'Save progress and return to main menu'
  ].freeze
  BET_OPTIONS = %i[player banker tie].freeze

  def display_startup_options
    TTY::Prompt.new.select(Rainbow('Welcome to The Ruby').red, STARTUP_OPTIONS)
  end

  def display_game_options
    TTY::Prompt.new.select('What would you like to do?', GAME_OPTIONS)
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
      q.validate(/\A\D{3,}\Z/, 'Please enter a valid name')
      q.modify(:capitalize)
    end
  end

  def ask_confirmation(msg)
    TTY::Prompt.new.yes?(msg)
  end
end
