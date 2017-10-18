class AddressesController < ApplicationController
  def create
    @form = AddressForm.new(address_form_params)

    if @form.invalid?
      @address_search = AddressSearch.new(postcode: @form.postcode)
      @back = Back.new(controller_name: 'describe_repair')

      @address_search_results = AddressFinder.new.find(@address_search)

      return render 'address_searches/create'
    end

    if @form.address_isnt_here?
      return redirect_to page_path('address_isnt_here')
    end

    api = HackneyApi.new
    address = api.get_property(property_reference: @form.property_reference)

    SelectedAnswerStore.new(session).store_selected_answers('address', address)

    redirect_to contact_details_with_callback_path
  end

  private

  def address_form_params
    params.require(:address_form).permit(:property_reference, :postcode)
  end
end
