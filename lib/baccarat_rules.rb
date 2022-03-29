module BaccaratRules
  # keys are the banker's third card
  # banker draws a third card if the player's
  # third card baccarat value is in the corresponding array(value)
  BANKER_RULES = {
    0 => [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
    1 => [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
    2 => [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
    3 => [0, 1, 2, 3, 4, 5, 6, 7, 9],
    4 => [2, 3, 4, 5, 6, 7],
    5 => [4, 5, 6, 7],
    6 => [6, 7],
    7 => []
  }.freeze

  ODDS = {
    player: 2,
    banker: 1.95,
    tie: 9
  }.freeze
end