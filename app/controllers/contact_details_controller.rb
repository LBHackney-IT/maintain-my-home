class ContactDetailsController < ApplicationController
  def index
    selected_answer_store = SelectedAnswerStore.new(session)
    @selected_answers = selected_answer_store.selected_answers['address']

    @form = ContactDetailsForm.new
    @back = Back.new(controller_name: 'address_searches')
  end

  def submit
    selected_answer_store = SelectedAnswerStore.new(session)
    @selected_answers = selected_answer_store.selected_answers['address']

    @back = Back.new(controller_name: 'address_searches')

    @form = ContactDetailsForm.new(contact_details_form_params)

    contact_details_saver =
      ContactDetailsSaver.new(selected_answer_store: selected_answer_store)
    callback_time_saver =
      CallbackTimeSaver.new(selected_answer_store: selected_answer_store)
    if contact_details_saver.save(@form) && callback_time_saver.save(@form)
      result =
        CreateRepair.new.call(answers: selected_answer_store.selected_answers)

      redirect_to confirmation_path(result.request_reference)
    else
      render :index
    end
  end

  private

  def contact_details_form_params
    params.require(:contact_details_form).permit!
  end
end
