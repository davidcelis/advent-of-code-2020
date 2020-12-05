class Map
  attr_reader :trees_hit

  def initialize(input)
    @map = File.read(input).split("\n")
    @length = @map.first.length
    @x, @y = [0, 0]
  end

  def traverse(right, down)
    @trees_hit = 0

    while @y < @map.length
      @trees_hit += 1 if tree?(@x, @y)
      @x = (@x + right) % @length
      @y += down
    end

    # Reset the position for traversal
    @x, @y = [0, 0]
  end

  private

  def tree?(x, y)
    @map[y][x] == '#'
  end
end

input = File.expand_path('input.txt', File.dirname(__FILE__))
map = Map.new(input)

# Part One

map.traverse(3, 1)
trees_hit = map.trees_hit

puts "Part One: moving 3 right and 1 down at a time, you'll hit #{trees_hit} trees"

# Part Two
map.traverse(1, 1); trees_hit *= map.trees_hit
map.traverse(5, 1); trees_hit *= map.trees_hit
map.traverse(7, 1); trees_hit *= map.trees_hit
map.traverse(1, 2); trees_hit *= map.trees_hit

puts "Part Two: your five test slopes multiply to a danger factor of #{trees_hit}"
