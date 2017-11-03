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
    persist_room(form)
    persist_sor_code(form)
  end

  def persist_room(form)
    return unless @question.id == 'which_room'
    @selected_answer_store.store_selected_answers(
      :room,
      room: form.answer
    )
  end

  def persist_sor_code(form)
    sor_code = @question.answer_data(form.answer)['sor_code']
    return unless sor_code
    @selected_answer_store.store_selected_answers(
      :diagnosis,
      sor_code: sor_code
    )
  end
end
