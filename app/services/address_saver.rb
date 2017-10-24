class AddressSaver
  def initialize(api: HackneyApi.new, selected_answer_store:)
    @api = api
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
    address = @api.get_property(property_reference: form.property_reference)
    @selected_answer_store.store_selected_answers('address', address)
  end
end
