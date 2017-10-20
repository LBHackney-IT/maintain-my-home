class AddressSearch
  attr_reader :form

  def initialize(search_params = {})
    @form = AddressSearchForm.new(search_params)
  end

  def back_link
    Back.new(controller_name: 'describe_repair').link
  end

  def results
    @results ||= AddressFinder.new.find(form)
  end
end
