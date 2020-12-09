class XMAS
  def self.decode(cypher_text)
    numbers = cypher_text.split("\n").map(&:to_i)

    numbers[25..].each.with_index(25) do |n, i|
      preamble = numbers[i-25...i]

      pair = preamble.combination(2).find { |a, b| a + b == n }

      raise ArgumentError.new("Encoding error at line #{i+1}: #{n} has no previous pair") unless pair
    end
  end
end

input = File.expand_path('input.txt', File.dirname(__FILE__))
cypher_text = File.read(input)

# Part One
XMAS.decode(cypher_text)
