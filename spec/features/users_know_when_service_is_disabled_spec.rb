require 'rails_helper'

RSpec.feature 'Users known when service is disabled' do
  scenario 'visiting the home page' do
    App.flipper.enable(:service_disabled)

    visit '/'

    expect(page).to have_content 'Sorry! This service is temporarily unavailable.'
  end

  scenario 'visiting a question page' do
    App.flipper.enable(:service_disabled)

    visit '/questions/which_room'

    expect(page).to have_content 'Sorry! This service is temporarily unavailable.'
  end

  scenario 'visiting a static content page' do
    App.flipper.enable(:service_disabled)

    visit '/pages/emergency_contact'

    expect(page).to have_content 'Sorry! This service is temporarily unavailable.'
  end
end
