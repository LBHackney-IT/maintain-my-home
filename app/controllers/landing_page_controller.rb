class LandingPageController < ApplicationController
  skip_before_action :check_service_status

  def index
    if service_disabled?
      redirect_to one_account
    else
      redirect_to '/'
    end
  end

  private

  def service_disabled?
    App.flipper.enabled?(:service_disabled)
  end

  def one_account
    ENV.fetch('ONE_ACCOUNT_URL', 'https://myaccount.hackney.gov.uk/')
  end
end
