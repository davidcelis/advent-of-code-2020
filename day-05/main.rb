class BoardingPass
  include Comparable

  def initialize(string)
    @instructions = string.split('')
    @row_instructions = @instructions.first(7)
    @column_instructions = @instructions.last(3)
  end

  def id
    @id ||= (seat_row * 8) + seat_column
  end

  def seat_row
    @seat_row ||= seek(:row, @row_instructions)
  end

  def seat_column
    @seat_column ||= seek(:column, @column_instructions)
  end

  def <=>(other)
    id <=> other.id
  end

  def inspect
    "Boarding Pass ##{id}: Row #{seat_row}, Column #{seat_column} (#{@instructions.join})"
  end

  private

  def seek(type, instructions)
    range = case type
              when :column then (0..8)
              when :row then (0..128)
            end
    items = range.to_a

    instructions.each do |instruction|
      case instruction
      when "L", "F" then items = items[0...(items.size / 2)]
      when "R", "B" then items = items[(-items.size / 2)..]
      end
    end

    items.first
  end
end

input = File.expand_path('input.txt', File.dirname(__FILE__))
batch = File.read(input).split("\n")
boarding_passes = batch.map { |item| BoardingPass.new(item) }

# Part One
puts "The highest seat ID in this batch of boarding passes is #{boarding_passes.max.id}"
