require 'rails_helper'

RSpec.feature 'Users understand the purpose of the service' do
  scenario 'sees the start page when visiting the root path' do
    visit '/'

    expect(page).to have_content 'Maintain my home'
    expect(page).to have_link 'Start'
  end
end
