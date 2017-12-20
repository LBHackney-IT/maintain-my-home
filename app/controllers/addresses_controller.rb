class AddressesController < ApplicationController
  def create
    @form = AddressForm.new(address_form_params)

    saver = AddressSaver.new(selected_answer_store: selected_answer_store)

    case saver.save(@form)
    when :success
      redirect_to address_success_path
    when :not_found
      redirect_to page_path('address_isnt_here')
    when :invalid
      @address_search = AddressSearch.new(postcode: @form.postcode)
      render 'address_searches/create'
    end
  end

  private

  def address_form_params
    params.require(:address_form).permit(:property_reference, :postcode)
  end

  def address_success_path
    if RepairParams.new(selected_answer_store.selected_answers).diagnosed?
      contact_details_path
    else
      contact_details_with_callback_path
    end
  end
end
