# Board: 3x3, with 9 squares
# loop through board and count the neighbours
# loop through board again and mark dying cell and new cell
# The second time, since I notice that I've made 3 mistake the last time:
# - invalid access to 2 dimentional array
# - only filter when index < 0 (not realizing that I'm checking for something in range, which has low limit & high limit)
# - only add new cell, not delete cell
# I no longer made those mistake, but I wonder if I can code in a way that reduce the number of mistake like that
# I've seen someone mentioned writing code top-down, which is a way SICP book is doing, I believe, so I think next time I'll try that
# An article that advocate for this method: https://www.teamten.com/lawrence/programming/write-code-top-down.html
#
class Square
  attr_accessor :has_cell, :neighbours_count
  alias_method :has_cell?, :has_cell

  def initialize(*args)
    @has_cell = false
    @neighbours_count = 0
  end
end

class Board
  def self.create(size)
    new(size)
  end

  def put_cell_to_position(i, j)
    @board[i-1][j-1].has_cell = true
  end

  def tick
   set_neigbors_for_all_cells
   generate
  end

  def to_s
    @board.map do |row|
      row.map do |square|
        square.has_cell ? "x" : "-"
      end.join
    end.join("\n")
  end

  def initialize(size)
    @board = (1..size).map do |row|
      (1..size).map do |col|
        Square.new
      end
    end
  end

  def set_neigbors_for_all_cells
    @board.each_with_index do |row, i|
      row.each_with_index do |col, j|
        neighbours_count = count_neigbors_of_cell(i, j)
        col.neighbours_count = neighbours_count
      end
    end
  end

  def generate
    @board.each do |row|
      row.each do |col|
        should_live?(col) ? col.has_cell = true : col.has_cell = false
      end
    end
  end

  def should_live?(col)
    (col.has_cell? && (col.neighbours_count == 2 || col.neighbours_count == 3)) ||
      (!col.has_cell? && (col.neighbours_count == 3))
  end

  def count_neigbors_of_cell(i, j)
    neighbours = [
      [i-1, j-1], [i-1, j], [i-1, j+1],
      [i, j-1], [i, j+1],
      [i+1, j-1], [i+1, j], [i+1, j+1]
    ]
    neighbours.select { |(i, j)| valid_index?(i, j) && @board[i][j].has_cell? }.size
  end

  def valid_index?(i, j)
    max_index = @board.length - 1
    i >= 0 && j >=0 && i <= max_index && j <= max_index
  end
end
