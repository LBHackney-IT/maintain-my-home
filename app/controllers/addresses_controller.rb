class AddressesController < ApplicationController
  def create
    @form = AddressForm.new(address_form_params)

    if @form.address_isnt_here?
      return redirect_to page_path('address_isnt_here')
    end

    selected_answer_store = SelectedAnswerStore.new(session)
    saver = AddressSaver.new(selected_answer_store: selected_answer_store)

    unless saver.save(@form)
      @address_search = AddressSearch.new(postcode: @form.postcode)
      return render 'address_searches/create'
    end

    if RepairParams.new(selected_answer_store.selected_answers).sor_code
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
