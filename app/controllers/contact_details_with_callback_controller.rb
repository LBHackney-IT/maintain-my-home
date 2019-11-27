class ContactDetailsWithCallbackController < ApplicationController
  def index
    @selected_answers = selected_answer_store.selected_answers['address']
    contact_details = selected_answer_store.selected_answers['contact_details']
    if contact_details
      default_values = {
        full_name: contact_details['full_name'],
        telephone_number: contact_details['telephone_number'],
      }
    else
      default_values = {}
    end
    @form = ContactDetailsWithCallbackForm.new(default_values)
  end

  def submit
    @selected_answers = selected_answer_store.selected_answers['address']

    @form = ContactDetailsWithCallbackForm.new(contact_details_form_params)

    contact_details_saver =
      ContactDetailsSaver.new(selected_answer_store: selected_answer_store)
    callback_time_saver =
      CallbackTimeSaver.new(selected_answer_store: selected_answer_store)
    if contact_details_saver.save(@form) && callback_time_saver.save(@form)
      result =
        CreateRepair.new.call(answers: selected_answer_store.selected_answers)
      GoogleSheetLoggingJob.perform_later(result.attributes, 'callback')

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
