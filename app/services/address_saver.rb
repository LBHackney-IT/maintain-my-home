class AddressSaver
  def initialize(api: HackneyApi.new, selected_answer_store:)
    @api = api
    @selected_answer_store = selected_answer_store
  end

  def save(form)
    if form.address_isnt_here?
      :not_found
    elsif form.valid?
      persist_answers(form)
      :success
    else
      :invalid
    end
  end

  private

  def persist_answers(form)
    address = @api.get_property(property_reference: form.property_reference)
    @selected_answer_store.store_selected_answers('address', address)
  end
end
