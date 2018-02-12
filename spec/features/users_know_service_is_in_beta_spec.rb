require 'rails_helper'

RSpec.feature 'Users know the site is in beta' do
  scenario 'when the site is enabled, a beta banner is displayed' do
    visit '/'

    expect(page).to have_content 'This is a new service'
  end

  scenario 'when the site is disabled, beta banner is hidden' do
    App.flipper.enable(:service_disabled)

    visit '/'

    expect(page).not_to have_content 'This is a new service'
  end
end
