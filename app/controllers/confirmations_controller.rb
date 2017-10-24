class ConfirmationsController < ApplicationController
  def show
    answers = SelectedAnswerStore.new(session).selected_answers
    @confirmation = Confirmation.new(
      request_reference: params[:id],
      answers: answers
    )
  end
end
