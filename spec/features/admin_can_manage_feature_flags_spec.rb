require 'rails_helper'

RSpec.feature 'Admin can manage feature flags' do
  scenario 'with correct credentials' do
    ClimateControl.modify(FLIPPER_AUTH_USER: 'admin', FLIPPER_AUTH_PASSWORD: 'letmein') do
      page.driver.browser.basic_authorize 'admin', 'letmein'
      visit '/feature_flags/'

      expect(page).to have_content 'Features'
    end
  end

  scenario 'without correct credentials' do
    visit '/feature_flags/'

    expect(page).to have_http_status(:unauthorized)
  end

  scenario 'with incorrect credentials' do
    ClimateControl.modify(FLIPPER_AUTH_USER: 'admin', FLIPPER_AUTH_PASSWORD: 'letmein') do
      page.driver.browser.basic_authorize 'wrong', 'wrong'

      visit '/feature_flags/'

      expect(page).to have_http_status(:unauthorized)
    end
  end
end
