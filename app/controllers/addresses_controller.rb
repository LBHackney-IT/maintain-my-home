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
    when :not_maintainable
      redirect_to page_path('cannot_report_repair')
    end
  end

  private

  def address_form_params
    params.require(:address_form).permit(:property_reference, :postcode)
  end

  def property_reference
    address_form_params[:property_reference]
  end

  def address_success_path
    if continue_to_appointment_booking?
      contact_details_path
    else
      contact_details_with_callback_path
    end
  end

  def continue_to_appointment_booking?
    RepairParams.new(selected_answer_store.selected_answers).diagnosed? && !cautionary_contact?
  end

  def cautionary_contact?
    result = HackneyApi.new.get_cautionary_contacts(property_reference: property_reference)
    return true unless result['results']['alertCodes'] == [nil] && result['results']['callerNotes'] == [nil]

    false
  end
end
