class ConfirmationsController < ApplicationController
  def show
    answers = SelectedAnswerStore.new(session).selected_answers
    @confirmation = Confirmation.new(
      repair_request_id: params[:id],
      answers: answers
    )
  end
end
