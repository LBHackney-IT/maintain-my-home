class ContactDetailsController < ApplicationController
  def index
    selected_answer_store = SelectedAnswerStore.new(session)
    @selected_answers = selected_answer_store.selected_answers['address']
  end

  def submit
    redirect_to confirmation_path('abc123')
  end
end
