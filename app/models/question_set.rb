class QuestionSet
  class Error < StandardError; end
  class UnknownQuestion < Error; end
  class BadlyFormattedYaml < Error; end

  def initialize(filename = 'db/questions.yml', partial_checker:, page_checker:)
    validator = QuestionsValidator.new(
      partial_checker: partial_checker,
      page_checker: page_checker,
      mandatory_questions: %w[which_room]
    )
    loader = QuestionSetLoader.new(validator: validator)
    file_path = Rails.root.join(filename)
    @questions = loader.load!(file_path)
  end

  def find(id)
    unless @questions.key?(id)
      raise UnknownQuestion, "Cannot find question with id '#{id}'"
    end

    params = @questions.fetch(id).merge('id' => id)
    Question.new(params)
  end

  class QuestionSetLoader
    def initialize(validator:)
      @validator = validator
    end

    def load!(file_path)
      yaml_data = File.read(file_path)
      parse_yaml(yaml_data).to_ruby.tap do |questions|
        @validator.validate!(questions)
      end
    end

    private

    def parse_yaml(yaml_data)
      YAML.parse(yaml_data)
    rescue => e
      raise BadlyFormattedYaml, e.message
    end
  end
end
