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

  def reset_repair_questions!
    @session[:selected_answers] = @session[:selected_answers].select do |key|
      %w[address contact_details].include? key
    end
  end

  def clear_address!
    selected_answers.delete('address')
  end

  def address?
    selected_address = selected_answers['address']
    selected_address.present? && selected_address.present?
  end
end
