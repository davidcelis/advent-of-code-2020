class BagGraph
  def initialize
    @graph = Hash.new { |h,k| h[k] = [] }
  end

  # This very basic "graph" pretty much just tracks: given a color (the key) of
  # bag, many other colors (the values) can hold this bag? The graph's
  # connections are kinda reversed, but it's to help us find our answer.
  def register(container, colors)
    colors.each do |color|
      @graph[color] << container
    end
  end

  def containers_for(color)
    all_containers = @graph[color]

    @graph[color].each do |container|
      all_containers += containers_for(container)
    end

    all_containers
  end
end

class Bag
  FORMAT = /(?:(\d+? ?\w+ \w+) bag)/

  def self.parse(text)
    text.scan(FORMAT).flatten
  end
end

bag_graph = BagGraph.new

input = File.expand_path('input.txt', File.dirname(__FILE__))
File.read(input).split("\n").each do |line|
  color, *others = Bag.parse(line)

  bag_graph.register(color, others)
end

# Part One
containers = bag_graph.containers_for("shiny gold").uniq

puts "A total of #{containers.size} differently colored bags can contain a shiny gold bag directly or indirectly."
