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

    @form = ContactDetailsForm.new(contact_details_form_params)
    return render :index unless @form.valid?

    redirect_to confirmation_path('abc123')
  end

  private

  def contact_details_form_params
    params.require(:contact_details_form).permit!
  end
end
