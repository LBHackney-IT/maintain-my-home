require 'rails_helper'

RSpec.feature 'Users understand the purpose of the service' do
  scenario 'sees the start page when visiting the root path' do
    visit '/'

    expect(page).to have_content 'Report a repair'
    expect(page).to have_link 'Start'
  end

  scenario 'sees the first question upon clicking the button' do
    visit '/'

    click_on 'Start'

    expect(page).to have_content 'Is your repair one of these emergencies?'
  end
end
