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

  def required_attributes_present?
    @birth_year && @issue_year && @expiration_year && @height && @hair_color && @eye_color && @passport_id
  end

  def valid?
    return false unless required_attributes_present?

    return false unless birth_year_valid?
    return false unless issue_year_valid?
    return false unless expiration_year_valid?
    return false unless height_valid?
    return false unless hair_color_valid?
    return false unless eye_color_valid?
    return false unless passport_id_valid?

    true
  end

  private

  def birth_year_valid?
    (1920..2002).include?(birth_year.to_i)
  end

  def issue_year_valid?
    (2010..2020).include?(issue_year.to_i)
  end

  def expiration_year_valid?
    (2020..2030).include?(expiration_year.to_i)
  end

  def height_valid?
    match = height.match(/\A(?<measurement>\d+)(?<unit>(in|cm))\z/)
    return false unless match

    case match[:unit]
    when "cm"
      (150..193).include?(match[:measurement].to_i)
    when "in"
      (56..76).include?(match[:measurement].to_i)
    else
      false
    end
  end

  def hair_color_valid?
    hair_color =~ /\A#[0-9a-f]{6}\z/i
  end

  def eye_color_valid?
    %w[amb blu brn gry grn hzl oth].include?(eye_color)
  end

  def passport_id_valid?
    passport_id =~ /\A\d{9}\z/
  end
end

input = File.expand_path('input.txt', File.dirname(__FILE__))
passport_batch = File.read(input)
passports = passport_batch.split("\n\n").map { |str| Passport.new(str) }

# Part One: valid as long as all fields (save cid, which is optional) are present:
valid_passports = passports.select(&:required_attributes_present?)
puts "Part One: #{valid_passports.count} passports have the required attributes"

# Part Two: valid as long as all fields are present and, themselves, valid. `cid` is still optional.
valid_passports = passports.select(&:valid?)
puts "Part Two: #{valid_passports.count} passports are truly valid"
