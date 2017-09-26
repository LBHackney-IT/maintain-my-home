class SelectedAnswerStore
  def initialize(session)
    @session = session
  end

  def store_selected_answers(key, value)
    selected_answers[key] = value
  end

  def selected_answers
    @session[:selected_answers] ||= {}
  end
end
