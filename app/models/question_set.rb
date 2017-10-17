class QuestionSet
  class UnknownQuestion < StandardError; end
  class BadlyFormattedYaml < StandardError; end
  class MissingQuestions < StandardError; end

  def initialize(filename = 'db/questions.yml')
    yaml_data = File.read(Rails.root.join(filename))

    begin
      parsed_yaml = YAML.parse(yaml_data)
    rescue => e
      raise BadlyFormattedYaml, e.message
    end

    @questions = parsed_yaml.to_ruby

    validate_questions
  end

  def find(id)
    unless @questions.key?(id)
      raise UnknownQuestion, "Cannot find question with id '#{id}'"
    end

    Question.new(@questions.fetch(id))
  end

  private

  def validate_questions
    question_ids = @questions.map { |k, _v| k }.uniq

    next_ids = @questions
               .map { |_k, v| Array(v['answers']).map { |a| a['next'] } }
               .flatten
               .compact

    missing_question_ids = next_ids - question_ids

    raise MissingQuestions, missing_question_ids if missing_question_ids.any?
  end
end

