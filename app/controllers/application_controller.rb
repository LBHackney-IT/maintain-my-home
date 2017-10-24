class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include Authentication

  def selected_answer_store
    @selected_answer_store ||= SelectedAnswerStore.new(session)
  end
end
