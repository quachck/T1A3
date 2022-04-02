require_relative 'lib/game'

def start_game
  game = Game.new
  game.start_menu
end

def start_app
  start_game if ARGV.length.zero?
  case ARGV[0]
  when '-h'
    Display.help_message
  when '-i'
    Display.info_message
  when '-r'
    Display.rule_message
  end
end

start_app
