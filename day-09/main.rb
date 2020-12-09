class XMAS
  class DecryptionError < StandardError
    attr_reader :line, :number

    def initialize(message = nil, line:, number:)
      @line = line
      @number = number

      super(message)
    end

    def message
      "Encoding error at line #{line}: #{number} has no previous pair"
    end
  end

  def initialize(cypher_text)
    @numbers = cypher_text.split("\n").map(&:to_i)
  end

  def decrypt
    @numbers[25..].each.with_index(25) do |n, i|
      preamble = @numbers[i-25...i]

      pair = preamble.combination(2).find { |a, b| a + b == n }

      raise DecryptionError.new(line: i + 1, number: n) unless pair
    end
  end

  def find_encryption_weakness(line)
    failed_number = @numbers[line - 1]

    @numbers[0...(line - 1)].each_with_index do |n, i|
      candidate_group = [n]

      while candidate_group.sum < failed_number
        candidate_group << @numbers[i += 1]
      end

      return (candidate_group.min + candidate_group.max) if candidate_group.sum == failed_number
    end
  end
end

input = File.expand_path('input.txt', File.dirname(__FILE__))
cypher_text = File.read(input)

xmas = XMAS.new(cypher_text)

# Part One, just let it error
begin
  xmas.decrypt
rescue XMAS::DecryptionError => e
  puts e.message

  # Part Two, use the information to find the encryption weakness
  weakness = xmas.find_encryption_weakness(e.line)
  puts "The encryption weakness was #{weakness}"
end
