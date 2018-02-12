class LandingPageController < ApplicationController
  skip_before_action :check_service_status

  def index
    if bouncing?
      redirect_to one_account
    else
      redirect_to '/'
    end
  end

  private

  def bouncing?
    App.flipper.enabled?(:bounce_to_one_account)
  end

  def one_account
    ENV.fetch('ONE_ACCOUNT_URL', 'https://myaccount.hackney.gov.uk/')
  end
end
