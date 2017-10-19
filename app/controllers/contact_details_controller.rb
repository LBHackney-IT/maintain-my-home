class ContactDetailsController < ApplicationController
  def index
    @form = ContactDetailsForm.new
  end

  def submit
    selected_answer_store = SelectedAnswerStore.new(session)

    @form = ContactDetailsForm.new(contact_details_form_params)

    contact_details_saver =
      ContactDetailsSaver.new(selected_answer_store: selected_answer_store)
    contact_details_saver.save(@form)

    redirect_to confirmation_path('WORK_ORDER_REFERENCE')
  end

  private

  def contact_details_form_params
    params.require(:contact_details_form).permit!
  end
end
