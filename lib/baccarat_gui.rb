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

  def draw_border(position, dimensions)
    puts TTY::Box.frame(
      left: position[0],
      top: position[1],
      width: dimensions[0],
      height: dimensions[1],
      border: :thick,
      title: { top_center: Rainbow("\u039B WELCOME TO THE RUBY \u039B").darkred, bottom_right: 'v(1.0)' }
    )
  end

  def draw_text(position, text, border_on, align, dimensions = [10, 3])
    puts TTY::Box.frame(
      left: position[0],
      top: position[1],
      width: dimensions[0],
      height: dimensions[1],
      align: align,
      border: {
        top: border_on,
        bottom: border_on,
        left: border_on,
        right: border_on
      }
    ) { text }
  end
end
