class QuestionSet
  class UnknownQuestion < StandardError; end

  attr_reader :questions

  def initialize(filename = 'db/questions.yml')
    yaml_data = File.read(Rails.root.join(filename))

    @questions = YAML.parse(yaml_data).to_ruby
  end

  def find(id)
    unless questions.key?(id)
      raise UnknownQuestion, "Cannot find question with id '#{id}'"
    end

    Question.new(questions.fetch(id))
  end
end

