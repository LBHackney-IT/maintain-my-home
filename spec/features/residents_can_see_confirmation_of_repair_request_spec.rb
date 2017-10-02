require 'rails_helper'

RSpec.feature 'Resident can see a confirmation of their repair request' do
  scenario 'when the repair request creation was successful' do
    visit '/confirmations/00012143'

    expect(page).to have_content 'Your reference number is 00012143'
  end
end
