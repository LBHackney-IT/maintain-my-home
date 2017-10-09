class AddressesController < ApplicationController
  def create
    @form = AddressForm.new(address_form_params)

    if @form.invalid?
      @address_search = AddressSearch.new(postcode: @form.postcode)

      address_finder = AddressFinder.new(HackneyApi.new)
      @address_search_results = address_finder.find(@address_search)

      return render 'address_searches/create'
    end

    return redirect_to address_isnt_here_path if @form.address_isnt_here?

    api = HackneyApi.new
    address = api.get_property(property_reference: @form.property_reference)

    SelectedAnswerStore.new(session).store_selected_answers('address', address)

    redirect_to contact_details_path
  end

  private

  def address_form_params
    params.require(:address_form).permit(:property_reference, :postcode)
  end
end
