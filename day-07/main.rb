# In the context of our graph, a Node represents a single bag.
class Node
  # The color of this bag, usually two words (e.g. posh black)
  attr_reader :color

  # An Array of Edges representing which bags (and how many of each) can
  # be held by this bag.
  attr_reader :edges

  def initialize(color)
    @color = color
    @edges = []
  end
end

# In the context of our graph, an Edge represents a directional connection
# between two bags (nodes). An edge is directional because one bag will contain
# a specific number of other bags.
class Edge
  # A bag that can contain other bags
  attr_reader :container

  # A bag that can be held by the container
  attr_reader :content

  # The number of bags that can be held by the container
  attr_reader :amount

  def initialize(container:, content:, amount:)
    @container = container
    @content = content
    @amount = amount
  end
end

class BagGraph
  BAG_CONTENT_SCANNER = /(?:(\d+? ?\w+ \w+) bag)/

  def initialize
    @nodes = []
    @edges = []
  end

  # A shortcut to pull a Bag from the graph without having to navigate edges.
  def find(color)
    @nodes.find { |b| b.color == color }
  end

  # Adds a new bag to the graph and returns it
  def add(color)
    Node.new(color).tap { |node| @nodes << node }
  end

  # Returns a Set of unique containers that can hold a given bag, whether
  # directly or by holding a bag that can, itself, hold the given bag.
  #
  # recursion: node => edges(node) => containers => edges(container) => more_containers
  def containers_for(node)
    containers = @edges.select { |edge| edge.content == node }.map(&:container)

    containers.each do |container|
      containers += containers_for(container)
    end

    containers.uniq
  end

  def register_bag_and_contents(bag_text)
    # First, separate the bag from its potential contents
    container_color, contents = bag_text.split(' bags contain ')

    # Either find the bag in the graph or, if not present yet, initialize it
    container = find(container_color) || add(container_color)

    # Use the regexp to scan for contents
    contents = contents.scan(BAG_CONTENT_SCANNER).flatten
    contents.each do |content|
      # Parse out the bag's color and how many can be held by the container
      amount = content.to_i
      content_color = content.sub(/\d+ /, '')

      # Either find the bag in the graph or, if not present yet, initialize it
      content = find(content_color) || add(content_color)

      # And, finally, create the edge representing how many of this bag the
      # container can hold. Both the node and the graph will reference it.
      edge = Edge.new(container: container, content: content, amount: amount)
      container.edges << edge
      @edges << edge
    end
  end
end

graph = BagGraph.new

input = File.expand_path('input.txt', File.dirname(__FILE__))
File.read(input).split("\n").each { |line| graph.register_bag_and_contents(line) }

# Part One
shiny_gold_bag = graph.find("shiny gold")
containers = graph.containers_for(shiny_gold_bag)

puts "A total of #{containers.size} differently colored bags can contain a shiny gold bag directly or indirectly."
