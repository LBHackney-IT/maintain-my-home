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

  def redirect_path_for_answer(chosen_answer)
    answer_hash = answers.detect { |answer| answer['text'] == chosen_answer }

    if answer_hash.key?('next')
      Rails.application.routes.url_helpers.questions_path(answer_hash['next'])
    elsif answer_hash.key?('page')
      Rails.application.routes.url_helpers.page_path(answer_hash['page'])
    else
      Rails.application.routes.url_helpers.describe_repair_path
    end
  end
end

