# The 3rd time, I tried the top down approach, which feels pretty nice
# At the begining, I feel like the approach is pretty similar to TDD
# So I tried TDD, but I realize there are several things that makes using TDD
# here awkward:
# - I want to have the whole skeleton of the program at the begining to see how
# everything fit together, but TDD doesn't seem to be aligned with that
# - TDD enforces me to know some implementation details (describe, context...)
# which add some additional overhead, which is not very nice
#
# So I figured out what suits me:
# 1. Write the basic skeleton of how the program behaves from the outside word
# For example:
# board = Board.create(11)
# board.put_cell_to_position(6, 4)
# board.tick
# 2. Implement the smallest step that works, and make sure I can see the result
# For example, for the above program, I tried to make
# board = Board.create(11)
# and print the result:
# board.current_state

class Square
  attr_accessor :has_cell, :neighbor_count
  alias_method :has_cell?, :has_cell
end

class Board
  def self.create(size)
    new(size)
  end

  def initialize(size)
    @board = (1..size).map do |row|
      (1..size).map do |col|
        Square.new
      end
    end
  end

  def current_state
    @board.each do |row|
      row.each do |col|
        col_state = col.has_cell? ? "x" : "-"
        print col_state
      end
      print "\n"
    end
  end

  def put_cell_to_position(i, j)
    @board[i-1][j-1].has_cell = true
  end

  def tick
    set_neighbor_count_for_all_cell
    generate_or_destroy_cell
  end

  def set_neighbor_count_for_all_cell
    @board.each_with_index do |row, i|
      row.each_with_index do |square, j|
        neighbor_count = count_neighbor_for_position(i, j)
        square.neighbor_count = neighbor_count
      end
    end
  end

  def generate_or_destroy_cell
    @board.each do |row|
      row.each do |square|
        square.has_cell = should_have_cell_after_tick?(square)
      end
    end
  end

  def should_have_cell_after_tick?(square)
    (square.has_cell? && square.neighbor_count <= 3 && square.neighbor_count >= 2) ||
      (!square.has_cell? && square.neighbor_count == 3)
  end

  def count_neighbor_for_position(i, j)
    neighbor_indexes = [
      [i-1, j-1], [i-1, j], [i-1, j+1],
      [i, j-1], [i, j+1],
      [i+1, j-1], [i+1, j], [i+1, j+1]
    ]
    max_index = @board.size - 1
    valid_neighbor_indexes = neighbor_indexes.select do |(neighbor_i, neighbor_j)|
      neighbor_i >= 0 && neighbor_i <= max_index &&
      neighbor_j >= 0 && neighbor_j <= max_index
    end
    valid_neighbor_indexes.select do |(neighbor_i, neighbor_j)|
      @board[neighbor_i][neighbor_j].has_cell?
    end.size
  end
end
