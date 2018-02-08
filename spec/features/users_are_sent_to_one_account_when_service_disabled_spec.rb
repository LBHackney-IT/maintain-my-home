require 'rails_helper'

RSpec.feature 'Users visiting our landing page from hackney.gov.uk' do
  scenario 'redirected to home page when service is enabled' do
    visit '/landing'

    expect(page.current_path).to eql '/'
    expect(page).to have_content 'We provide housing and communal area repairs for council tenants'
  end

  scenario 'redirected to One Account, when service is disabled' do
    App.flipper.enable(:service_disabled)

    visit '/landing'

    expect(page.current_url).to eql 'https://myaccount.hackney.gov.uk/'
  end

  scenario 'redirected to another URL, when service is disabled and ONE_ACCOUNT_URL is set' do
    ClimateControl.modify(ONE_ACCOUNT_URL: 'https://exampleurl.com/') do
      App.flipper.enable(:service_disabled)

      visit '/landing'

      expect(page.current_url).to eql 'https://exampleurl.com/'
    end
  end
end
