class AddressesController < ApplicationController
  def create
    @form = AddressForm.new(address_form_params)

    if @form.address_isnt_here?
      return redirect_to page_path('address_isnt_here')
    end

    saver = AddressSaver.new(selected_answer_store: selected_answer_store)

    if saver.save(@form) == :invalid
      @address_search = AddressSearch.new(postcode: @form.postcode)
      return render 'address_searches/create'
    end

    if RepairParams.new(selected_answer_store.selected_answers).diagnosed?
      redirect_to contact_details_path
    else
      redirect_to contact_details_with_callback_path
    end
  end

  private

  def address_form_params
    params.require(:address_form).permit(:property_reference, :postcode)
  end
end
