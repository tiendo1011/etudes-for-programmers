require File.expand_path("game_of_life.rb", __dir__)

board = Board.create(11)
board.current_state

board.put_cell_to_position(6, 4)
board.put_cell_to_position(6, 5)
board.put_cell_to_position(6, 6)
board.put_cell_to_position(6, 7)
board.put_cell_to_position(6, 8)
board.current_state

(1..9).each do
  board.tick
  board.current_state
end
