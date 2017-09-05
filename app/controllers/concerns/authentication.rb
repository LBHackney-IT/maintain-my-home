module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate
  end

  private

  def authenticate
    return if ENV['HTTP_AUTH_USER'].nil? && ENV['HTTP_AUTH_PASSWORD'].nil?

    return if authenticate_with_http_basic do |username, password|
      ENV['HTTP_AUTH_USER'] == username && ENV['HTTP_AUTH_PASSWORD'] == password
    end

    request_http_basic_authentication
  end
end
