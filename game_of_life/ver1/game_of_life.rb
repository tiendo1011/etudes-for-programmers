# rules:
# cell has 2 or three neighbors survive
# empty cell has three neighors creates a new cell
# solution:
# has a board:
# [
# [- - -],
# [- - -],
# [- - -]
# ]
# iterate over the board, count the number of neighbors and save it to each square
# board has a tick method, that goes over all square, and mark it as having cell or
# not base on its neighbors
#
# how to count the neighbors? find the immediate neighbors position
# position p(i, j) will have neighbors:
# (i-1, j-1), (i-1, j), (i-1, j+1)
# (i, j-1), (i, j+1)
# (i+1, j-1), (i+1, j), (i+1, j+1)
# count the number of neighbors has_cell
#
# tick method goes over board, if the number of neighbors is good, set has_cell = true,
# otherwise set to false
#
# Discovered mistakes:
# 1. Access matrix in a wrong way: often think of board[i, j] while it should be board[i][j]
# 2. boundary condition:
# for board 3x3 element
# only think about invalid element at the lower bound (< 0), but not think about upper bound (> 2)
# 3. Only set has_cell to true for new cell, but forget to set has_cell = false for dying cell
# should_have_cell(square) ? square.has_cell = true : square.has_cell = false

class Square
  attr_accessor :neighbors_count, :has_cell, :i, :j

  def initialize(i, j)
    @i = i
    @j = j
    @neighbors_count = 0
    @has_cell = false
  end

  def to_s
    "#{i}x#{j}"
  end
end

class Board
  def self.create(size)
    new(size)
  end

  def put_cell_to_position(i, j)
    raise ArgumentError, "position must > 0" if i < 1 || j < 1

    @board[i - 1][j - 1].has_cell = true
  end

  def tick
    set_neighbors_count_for_all_squares
    determine_has_cell_for_all_squares
  end

  def to_s
    @board.map do |row|
      row.map do |square|
        square.has_cell ? "x" : "-"
      end.join
    end.join("\n")
  end

  private
  def initialize(size)
    raise ArgumentError, "support numeric value only" unless size.is_a?(Numeric)
    raise ArgumentError, "board size must > 0" if size == 0

    @size = size
    @board = (0..size-1).map do |i|
      (0..size-1).map do |j|
        Square.new(i, j)
      end
    end
  end

  def set_neighbors_count_for_all_squares
    @board.each do |row|
      row.each do |square|
        set_neighbors_count_for(square)
      end
    end
  end

  def set_neighbors_count_for(square)
    square.neighbors_count = neighbors_of(square).filter(&:has_cell).size
  end

  def neighbors_of(square)
    neighbors_positions(square).map do |(i, j)|
      @board[i][j]
    end
  end

  def neighbors_positions(square)
    i = square.i
    j = square.j
    [
      [i-1, j-1], [i-1, j], [i-1, j+1],
      [i, j-1], [i, j+1],
      [i+1, j-1], [i+1, j], [i+1, j+1]
    ].filter do |(x, y)|
      0 <= x && x < @size && 0 <= y && y < @size
    end
  end

  def determine_has_cell_for_all_squares
    @board.each do |row|
      row.each do |square|
        should_have_cell(square) ? square.has_cell = true : square.has_cell = false
      end
    end
  end

  def should_have_cell(square)
    (square.has_cell && (square.neighbors_count == 2 || square.neighbors_count == 3)) ||
      (!square.has_cell && square.neighbors_count == 3)
  end
end

board = Board.create(11)
board.put_cell_to_position(6, 4)
board.put_cell_to_position(6, 5)
board.put_cell_to_position(6, 6)
board.put_cell_to_position(6, 7)
board.put_cell_to_position(6, 8)

puts "first generation"
puts board.to_s

9.times do |i|
  puts "generation: #{i+2}"
  board.tick
  puts board.to_s
end
