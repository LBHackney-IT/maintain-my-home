require 'rails_helper'

RSpec.feature 'Users can answer repair questions' do
  scenario 'Users can see an initial question, with a number of possible answers' do
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

  scenario 'Users cannot submit the form without answering the question' do
    visit '/questions/start/'
    click_continue

    within '.flash-alert' do
      expect(page).to have_content t('errors.no_selection')
    end
  end

  scenario "Users can choose 'Yes' and get shown the emergency contact page" do
    visit '/questions/start/'
    choose_radio_button t('simple_form.options.start_form.priority_repair.yes')
    click_continue

    expect(page).to have_content 'Please call our repair centre'
  end

  scenario "Users can choose 'No' and is shown the next question" do
    visit '/questions/start/'
    choose_radio_button t('simple_form.options.start_form.priority_repair.no')
    click_continue

    within '.question' do
      expect(page).to have_content 'Is there anything else we should know about this problem?'
    end
  end

  private

  def click_continue
    click_button t('helpers.submit.create')
  end
end
