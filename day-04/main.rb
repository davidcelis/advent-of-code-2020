class Passport
  attr_reader :birth_year, :issue_year, :expiration_year, :height, :hair_color, :eye_color, :passport_id, :country_id

  def initialize(passport_string)
    pairs = passport_string.split.map(&:strip).map { |pair| pair.split(':') }
    @attributes = Hash[pairs]

    @birth_year = @attributes['byr']
    @issue_year = @attributes['iyr']
    @expiration_year = @attributes['eyr']
    @height = @attributes['hgt']
    @hair_color = @attributes['hcl']
    @eye_color = @attributes['ecl']
    @passport_id = @attributes['pid']
    @country_id = @attributes['cid']
  end

  def valid?
    @birth_year && @issue_year && @expiration_year && @height && @hair_color && @eye_color && @passport_id
  end
end

input = File.expand_path('input.txt', File.dirname(__FILE__))
passport_batch = File.read(input)
passports = passport_batch.split("\n\n").map { |str| Passport.new(str) }

# Part One: valid as long as all fields (save cid, which is optional) are present:
valid_passports = passports.select { |p| p.valid? }
puts "Part One: #{valid_passports.count} passports are valid"
