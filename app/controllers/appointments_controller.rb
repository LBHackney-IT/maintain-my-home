class AppointmentsController < ApplicationController
  def new
    selected_answer_store = SelectedAnswerStore.new(session)
    @selected_answers = selected_answer_store.selected_answers['address']
  end
end
