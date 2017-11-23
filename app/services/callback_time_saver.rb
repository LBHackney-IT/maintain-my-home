class CallbackTimeSaver
  def initialize(selected_answer_store:)
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
    @selected_answer_store.store_selected_answers(
      'callback_time',
      'callback_time' => form.callback_time,
    )
  end
end
