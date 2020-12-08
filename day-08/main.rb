class GameOS
  attr_reader :accumulator

  def initialize(program)
    # Given a file containing the program to be interpreted by GameOS, coerce
    # it into a hash where the keys are the numeric lines of code, and the
    # value is the instruction at that line in the program. Like in any editor,
    # the first line of code is line 1, not line 0.
    lines = program.split("\n")
    @instructions = Hash[(1...lines.length).zip(lines)]

    # The accumulator is incremented or decremented by the `acc` operation
    @accumulator = 0

    # The current_line is updated by `jmp` operations or, for other operations,
    # simply incremented by 1.
    @current_line = 1

    # By keeping track of which lines we've already executed, we can detect any
    # infinite loops. If we enter an infinite loop, a SystemStackError
    # exception is raised.
    @lines_executed = []

    # If we enter an infinite loop, we'll attempt to fix corrupted instructions.
    # To do so, we look for the first `jmp` or `nop` instruction and change it
    # to the other. Then, we reset the counters and run the game again. If we
    # still have an infinite loop, the first thing we'll do is change the most
    # recent line _back to its original instruction_ and then try the next one.
    @lines_changed_to_test_corruption = []
  end

  def run(fix_corruption: true)
    # Enter the game loop.
    loop do
      # If we've already run this line of code, we have an infinite loop and
      # should simply give up. Raise an error.
      raise SystemStackError.new("stack level too deep") if @lines_executed.include?(@current_line)

      # If not, track that we've executed it
      @lines_executed << @current_line

      # Then, find and parse the instruction...
      instruction = @instructions[@current_line]

      # If there's no instruction, we've reached the end of our program and can
      # safely exit the game loop.
      break unless instruction

      # Otherwise, run it, updating the accumulator and/or the @current_line.
      method, arg = instruction.split(' ')
      send(method, arg)
    end
  rescue SystemStackError => e
    raise(e) unless fix_corruption

    # Find the first `nop` or `jmp` instruction that is not referenced in the
    # `@known_uncorrupted_lines` tracker.
    line, instruction = @instructions.find do |line, instruction|
      !@lines_changed_to_test_corruption.include?(line) && (instruction.start_with?('nop') || instruction.start_with?('jmp'))
    end

    # Take the most recently changed line and swap it back
    previously_changed_line = @lines_changed_to_test_corruption.last
    swap_instruction(previously_changed_line) if previously_changed_line

    # Change the next instruction...
    swap_instruction(line)
    @lines_changed_to_test_corruption << line

    # ... reset the accumulator and current line...
    @accumulator = 0
    @current_line = 1
    @lines_executed = []

    # ... and restart the game
    retry
  end

  private

  def acc(counter)
    @accumulator += counter.to_i
    @current_line += 1
  end

  def jmp(counter)
    @current_line += counter.to_i
  end

  def nop(*)
    @current_line += 1
  end

  def swap_instruction(line)
    if @instructions[line].start_with?('nop')
      @instructions[line].sub!(/nop/, 'jmp')
    elsif @instructions[line].start_with?('jmp')
      @instructions[line].sub!(/jmp/, 'nop')
    end
  end
end

input = File.expand_path('input.txt', File.dirname(__FILE__))
program = File.read(input)

# First, initialize the OS with the original program
game = GameOS.new(program)

# Part One
begin
  game.run(fix_corruption: false)
rescue SystemStackError => e
  puts "Before recognizing the infinite loop, the accumulator was set to #{game.accumulator}"
end

# Part Two
game.run
puts "GameOS booted successfully with accumulator set to #{game.accumulator}"
