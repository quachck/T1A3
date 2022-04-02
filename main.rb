require_relative 'lib/game'

def start_game
  Display.print_title
  game = Game.new
  game.start_menu
end

start_game
