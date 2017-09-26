require 'rails_helper'

RSpec.feature 'User can diagnose repair' do
  scenario 'User can see an initial question, with a number of possible answers' do
    visit '/questions/start/'

    within '.question' do
      expect(page).to have_content 'Is your problem one of these?'
    end

    within '.answers' do
      expect(page).to have_content 'Yes'
      expect(page).to have_content 'No'
    end

    expect(page).to have_button t('helpers.submit.create')
  end
end
