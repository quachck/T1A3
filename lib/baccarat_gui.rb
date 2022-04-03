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
      title: { top_center: Rainbow("Λ WELCOME TO THE RUBY Λ").darkred, bottom_right: 'v(1.0)' }
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

  def draw_table(dealer_info, player_result, results, balance, bet_info, card_count, new_shoe_msg)
    system 'clear'
    draw_text([16, 4], "PLAYER#{' ' * 35}BANKER", false, :left, [50, 3])
    draw_text([31, 7], "#{results[0]}  #{result.to_s.upcase}!  #{results[1]}", false, :center, [20, 3])
    draw_text([2, 10], "PLAYER PAYS 1:1\nBANKER PAYS 1:1\nTIE PAYS 8:1", true, :left, [25, 5])
    draw_text([28, 10], "#{Rainbow("BALANCE: Λ#{balance}\n").gold}#{Rainbow("BET: Λ#{bet_info[1]} ON #{bet_info[0].upcase}").blue}", true, :center, [25, 5])
    draw_text([54, 10], "HISTORY:\n#{dealer_info[2].join(' ')}", true, :left, [25, 5])
    draw_text([25, 17], player_result, false, :center, [30, 5])
    draw_text([2, 15], "CARDS LEFT IN SHOE:\n#{card_count}", true, :left, [25, 5])
    draw_text([31, 3], new_shoe_msg, false, :center, [25, 1])

    draw_card([10, 5], dealer_info[0][0])
    draw_card([17, 5], dealer_info[0][1])
    draw_card([24, 5], dealer_info[0][2])

    draw_card([50, 5], dealer_info[1][0])
    draw_card([57, 5], dealer_info[1][1])
    draw_card([64, 5], dealer_info[1][2])

    draw_border([0, 0], [81, 22])
  end
end
