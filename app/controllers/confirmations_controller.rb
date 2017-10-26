class ConfirmationsController < ApplicationController
  def show
    @confirmation = Confirmation.new(
      request_reference: params[:id],
      answers: selected_answer_store.selected_answers
    )
  end
end
