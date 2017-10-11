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
    return render :index unless contact_details_saver.save(@form)

    redirect_to confirmation_path('abc123')
  end

  private

  def contact_details_form_params
    params.require(:contact_details_form).permit!
  end
end
