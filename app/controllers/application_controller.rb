class ApplicationController < ActionController::Base
  class ServiceDisabled < StandardError; end

  before_action :check_service_status

  protect_from_forgery with: :exception

  rescue_from ServiceDisabled do
    render 'errors/service_disabled'
  end

  rescue_from JsonApi::ApiError do |e|
    logger.error "[Handled] #{e.class}: #{e.message}"
    render 'errors/api_error'
  end

  include Authentication

  def selected_answer_store
    @selected_answer_store ||= SelectedAnswerStore.new(session)
  end

  def description_partial_checker
    DescriptionPartialChecker.new(lookup_context: lookup_context)
  end

  def check_service_status
    raise ServiceDisabled if App.flipper.enabled?(:service_disabled)
  end
end
