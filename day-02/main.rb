class Password
  FORMAT = /\A(?<lower>\d+)-(?<upper>\d+) (?<letter>\w): (?<password>.+)\z/

  attr_reader :lower
  attr_reader :upper
  attr_reader :required_letter
  attr_reader :string

  def initialize(password_with_policy)
    match = password_with_policy.match(FORMAT)

    @lower = match[:lower].to_i
    @upper = match[:upper].to_i

    @string = match[:password]
    @required_letter = match[:letter]
  end
end

class StandardPolicy
  def self.validate(password)
    letter_count = password.string.split("").count(password.required_letter)

    (password.lower..password.upper).include?(letter_count)
  end
end

class PositionalPolicy
  def self.validate(password)
    (
      password.string[password.lower - 1] == password.required_letter
    ) ^ ( # XOR: Exactly of these two conditions can be true. Not zero, not both.
      password.string[password.upper - 1] == password.required_letter
    )
  end
end

valid_passwords_by_letter_count = 0
valid_passwords_by_letter_position = 0

input = File.expand_path('input.txt', File.dirname(__FILE__))
File.readlines(input).each do |line|
  password = Password.new(line.strip)

  # Part One
  valid_passwords_by_letter_count += 1 if StandardPolicy.validate(password)

  # Part Two
  valid_passwords_by_letter_position += 1 if PositionalPolicy.validate(password)
end

puts "#{valid_passwords_by_letter_count} passwords are valid for Part One"
puts "#{valid_passwords_by_letter_position} passwords are valid for Part Two"
