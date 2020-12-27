require File.expand_path("run.rb", __dir__)

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
