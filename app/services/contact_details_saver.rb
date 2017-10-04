class ContactDetailsSaver
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
      :contact_details,
      full_name: form.full_name,
      telephone_number: form.telephone_number,
      callback_time: form.callback_time,
    )
  end
end
