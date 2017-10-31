require 'rails_helper'

RSpec.feature 'Users can answer repair questions' do
  scenario 'Users can see an initial question, with a number of possible answers' do
    visit '/questions/start/'

    within '.question' do
      expect(page).to have_content 'Do any of the following apply'
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

    within '.start_form_answer' do
      expect(page).to have_css '.error-message'
      expect(page).to have_content t('errors.messages.blank')
    end
  end

  scenario "Users can choose 'Yes' and get shown the emergency contact page" do
    visit '/questions/start/'
    choose_radio_button t('simple_form.options.start_form.answer.yes')
    click_continue

    expect(page).to have_content 'Emergency repairs'
  end

  scenario "Users can choose 'No' and is shown the next question" do
    visit '/questions/start/'
    choose_radio_button t('simple_form.options.start_form.answer.no')
    click_continue

    within '.question' do
      expect(page).to have_content 'Where is the problem located?'
    end
  end

  private

  def click_continue
    click_button t('helpers.submit.create')
  end
end
