class GameOS
  attr_reader :accumulator

  def initialize(program)
    # Split the program into a list of instructions, and coerce them into a
    # hash where the keys are the numeric lines of code, and the value is
    # the instruction at that line in the program. Like in any editor, the
    # first line of code is line 1, not line 0.
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
  end

  def run
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
end

input = File.expand_path('input.txt', File.dirname(__FILE__))
program = File.read(input)
game = GameOS.new(program)

# Part One
begin
  game.run
rescue SystemStackError => e
  puts "Before recognizing the infinite loop, the accumulator was set to #{game.accumulator}"
end
