class AddressesController < ApplicationController
  def create
    if property_reference.blank?
      return redirect_to(
        new_address_search_path,
        alert: t('addresses.errors.blank')
      )
    end

    api = HackneyApi.new
    address = api.get_property(property_reference: property_reference)

    SelectedAnswerStore.new(session).store_selected_answers('address', address)

    redirect_to new_appointment_path
  end

  private

  def update_params
    params.require(:address).permit(:property_reference)
  end

  def property_reference
    update_params[:property_reference]
  end
end
