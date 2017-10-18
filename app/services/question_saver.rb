class QuestionSaver
  def initialize(question:, selected_answer_store:)
    @question = question
    @selected_answer_store = selected_answer_store
  end

  def save(form)
    if form.valid?
      persist_answers(form)
      true
    else
      false
    end
  end

  private

  def persist_answers(form)
    sor_code = @question.answer_data(form.answer)['sor_code']
    return unless sor_code
    @selected_answer_store.store_selected_answers(
      :diagnosis,
      sor_code: sor_code
    )
  end
end
