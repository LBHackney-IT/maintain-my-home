class Question
  class InvalidAnswerError < StandardError; end

  attr_reader :id
  attr_reader :title

  def initialize(question_hash)
    @id = question_hash['id']
    @title = question_hash['question']
    @answers = question_hash['answers'] || []
    @route_helpers = Rails.application.routes.url_helpers
  end

  def answers_for_collection
    @answers.map { |answer| answer['text'] }
  end

  def answer_data(chosen_answer)
    @answers.detect { |answer| answer['text'] == chosen_answer }.tap do |data|
      raise InvalidAnswerError if data.nil?
    end
  end

  def redirect_path_for_answer(chosen_answer)
    answer_hash = answer_data(chosen_answer)

    if answer_hash.key?('next')
      @route_helpers.questions_path(answer_hash['next'])
    elsif answer_hash.key?('page')
      @route_helpers.page_path answer_hash['page'], details: answer_hash['desc']
    elsif answer_hash.key?('desc')
      @route_helpers.describe_repair_path(details: answer_hash['desc'])
    else
      @route_helpers.describe_repair_path
    end
  end
end
