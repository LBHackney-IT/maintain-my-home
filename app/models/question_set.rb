class QuestionSet
  class Error < StandardError; end
  class UnknownQuestion < Error; end
  class BadlyFormattedYaml < Error; end

  def initialize(filename = 'db/questions.yml', partial_checker:)
    loader = QuestionSetLoader.new(partial_checker: partial_checker)
    file_path = Rails.root.join(filename)
    @questions = loader.load!(file_path)
  end

  def find(id)
    unless @questions.key?(id)
      raise UnknownQuestion, "Cannot find question with id '#{id}'"
    end

    Question.new(id, @questions.fetch(id))
  end

  class QuestionSetLoader
    def initialize(partial_checker:)
      @partial_checker = partial_checker
    end

    def load!(file_path)
      yaml_data = File.read(file_path)
      questions = parse_yaml(yaml_data).to_ruby

      QuestionsValidator
        .new(
          questions,
          partial_checker: @partial_checker,
          mandatory_questions: %w[location which_room]
        ).validate!

      questions
    end

    private

    def parse_yaml(yaml_data)
      YAML.parse(yaml_data)
    rescue => e
      raise BadlyFormattedYaml, e.message
    end
  end
end
