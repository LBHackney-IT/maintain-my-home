class AddressSaver
  def initialize(api: HackneyApi.new, selected_answer_store:)
    @api = api
    @selected_answer_store = selected_answer_store
  end

  def save(form)
    if form.address_isnt_here?
      :not_found
    elsif !form.valid?
      :invalid
    else
      persist_answers(form)
    end
  end

  private

  def persist_answers(form)
    address = @api.get_property(property_reference: form.property_reference)
    if maintainable?(address)
      @selected_answer_store.store_selected_answers('address', address)
      :success
    else
      :not_maintainable
    end
  end

  def maintainable?(address)
    address.fetch('maintainable', true)
  end
end
