class AddressesController < ApplicationController
  def update
    selected_answers_store = SelectedAnswerStore.new(session)

    property_reference = update_params[:property_reference]

    api = HackneyApi.new
    address = api.get_property(property_reference: property_reference)

    selected_answers_store.store_selected_answers('address', address)

    redirect_to new_appointment_path
  end

  private

  def update_params
    params.require(:address).permit(:property_reference)
  end
end
