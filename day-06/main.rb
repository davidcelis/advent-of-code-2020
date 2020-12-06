require 'set'

class SurveyGroup
  def initialize(group)
    @surveys = group.split("\n").map { |survey| survey.split('').to_set }
  end

  def questions_answered_by_anyone
    @surveys.reduce(&:union)
  end

  def questions_answered_by_everyone
    @surveys.reduce(&:intersection)
  end
end

input = File.expand_path('input.txt', File.dirname(__FILE__))
batch = File.read(input).split("\n\n")
survey_groups = batch.map { |b| SurveyGroup.new(b) }

# Part One

sum = survey_groups.
  map(&:questions_answered_by_anyone).
  map(&:count).
  reduce(&:+)

puts "The sum of unique questions answered per group was #{sum}"

# Part Two

sum = survey_groups.
  map(&:questions_answered_by_everyone).
  map(&:count).
  reduce(&:+)

puts "The sum of questions per group that were answered by everyone in that group was #{sum}"
