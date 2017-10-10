class Question
  attr_reader :title
  attr_reader :answers

  def initialize(question_hash)
    @title = question_hash['question']
    @answers = question_hash['answers']
  end

  def answers_for_collection
    answers.map { |answer| answer['text'] }
  end
end

