class ContactDetailsController < ApplicationController
  def index
    @back = Back.new(controller_name: 'address_searches')
    @form = ContactDetailsForm.new
  end

  def submit
    selected_answer_store = SelectedAnswerStore.new(session)

    @back = Back.new(controller_name: 'address_searches')
    @form = ContactDetailsForm.new(contact_details_form_params)

    contact_details_saver =
      ContactDetailsSaver.new(selected_answer_store: selected_answer_store)

    if contact_details_saver.save(@form)
      result =
        CreateRepair.new.call(answers: selected_answer_store.selected_answers)

      redirect_to confirmation_path(result.work_order_reference)
    else
      render :index
    end
  end

  private

  def contact_details_form_params
    params.require(:contact_details_form).permit!
  end
end
