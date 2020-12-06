class SurveyGroup
  def initialize(group)
    @text = group
  end

  def all_questions_answered
    @text.gsub(/\s+/, '').split('').uniq
  end
end

input = File.expand_path('input.txt', File.dirname(__FILE__))
batch = File.read(input).split("\n\n")
survey_groups = batch.map { |b| SurveyGroup.new(b) }

# Part One

sum = survey_groups.
  map(&:all_questions_answered).
  map(&:count).
  reduce(&:+)

puts "The sum of unique questions answered per group was #{sum}"
