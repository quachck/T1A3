require 'tty-box'
require 'rainbow'

module BaccaratGUI
  def draw_card(position, card)
    puts TTY::Box.frame(
      left: position[0],
      top: position[1],
      width: 6,
      height: 4
    ) { "#{card.short_hand_value}#{card.suit_icon}" }
  end
end
