class QuestionSet
  class Error < StandardError; end
  class UnknownQuestion < Error; end
  class BadlyFormattedYaml < Error; end

  def initialize(filename = 'db/questions.yml', partial_checker:)
    yaml_data = File.read(Rails.root.join(filename))

    begin
      parsed_yaml = YAML.parse(yaml_data)
    rescue => e
      raise BadlyFormattedYaml, e.message
    end

    @questions = parsed_yaml.to_ruby

    QuestionsValidator
      .new(@questions, partial_checker: partial_checker)
      .validate!
  end

  def find(id)
    unless @questions.key?(id)
      raise UnknownQuestion, "Cannot find question with id '#{id}'"
    end

    Question.new(@questions.fetch(id))
  end
end
