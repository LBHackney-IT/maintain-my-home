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

    QuestionValidator.new(@questions).validate!
  end

  def find(id)
    unless @questions.key?(id)
      raise UnknownQuestion, "Cannot find question with id '#{id}'"
    end

    Question.new(@questions.fetch(id))
  end

  class QuestionValidator
    def initialize(questions)
      @questions = questions
    end

    def validate!
      validate_next
    end

    private

    def validate_next
      question_ids = @questions.keys.uniq
      missing_question_ids = answer_values_for('next') - question_ids

      raise MissingQuestions, missing_question_ids if missing_question_ids.any?
    end

    def answer_values_for(answer_type)
      @questions.reduce([]) do |ids, (_k, v)|
        answers = Array(v['answers'])
        ids + answers.map { |a| a[answer_type] }.compact
      end
    end
  end
end
