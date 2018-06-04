class ContactDetailsController < ApplicationController
  def index
    contact_details = selected_answer_store.selected_answers['contact_details']
    if contact_details
      default_values = {
        full_name: contact_details['full_name'],
        telephone_number: contact_details['telephone_number'],
      }
    else
      default_values = {}
    end
    @form = ContactDetailsForm.new(default_values)
  end

  def submit
    @form = ContactDetailsForm.new(contact_details_form_params)

    contact_details_saver =
      ContactDetailsSaver.new(selected_answer_store: selected_answer_store)

    if contact_details_saver.save(@form)
      result = save_and_log_repair
      redirect_to appointments_path(result.request_reference)
    else
      render :index
    end
  end

  private

  def contact_details_form_params
    params.require(:contact_details_form).permit!
  end

  def save_and_log_repair
    result =
      CreateRepair.new.call(answers: selected_answer_store.selected_answers)
    GoogleSheetLogger.new.call(result, 'booking')
    result
  end
end
