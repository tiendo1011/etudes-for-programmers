class Test
  attr_accessor :has_cell
  alias has_cell? has_cell

  def initialize(*args)
    @has_cell = false
  end
end

puts Test.new.has_cell?
