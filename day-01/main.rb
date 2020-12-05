class ExpenseReport
  attr_reader :entries

  def initialize(path)
    @entries = File.read(path).split.map(&:to_i)
  end

  def find_pair_with_sum(sum)
    # Don't modify the original expense report.
    recursively_find_pair(@entries.dup, sum)
  end

  def find_triplet_with_sum(sum)
    # Don't modify the original expense report.
    recursively_find_triplet(@entries.dup, sum)
  end

  private

  def recursively_find_pair(entries, sum)
    # If we only have one entry left, we have nothing to sum, and there's
    # likely no pair in the expense report that add up to the requested sum.
    return unless entries.size > 1

    entry = entries.shift
    other = entries.find { |e| (entry + e) == sum }
    return [entry, other] if other

    recursively_find_pair(entries, sum)
  end

  def recursively_find_triplet(entries, sum)
    entry = entries.shift
    remainder = sum - entry

    candidates = recursively_find_pair(entries.dup, remainder)
    return [entry, *candidates] if candidates

    recursively_find_triplet(entries, sum)
  end
end

input = File.expand_path('input.txt', File.dirname(__FILE__))
expense_report = ExpenseReport.new(input)

# Part One
pair = expense_report.find_pair_with_sum(2020)
puts "Found two entries that add up to 2020: #{pair.join(', ')}"
puts "Multiplied together, the answer is #{pair.reduce(:*)}\n\n"

# Part Two
triplet = expense_report.find_triplet_with_sum(2020)
puts "Found three entries that add up to 2020: #{triplet.join(', ')}"
puts "Multiplied together, the answer is #{triplet.reduce(:*)}"
