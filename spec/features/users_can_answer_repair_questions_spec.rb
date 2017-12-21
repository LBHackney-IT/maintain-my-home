require 'rails_helper'

RSpec.feature 'Users can answer repair questions' do
  scenario 'Users can see an initial question, with a number of possible answers' do
    visit '/questions/start/'

    within '.question' do
      expect(page).to have_content 'Do any of the following apply'
    end

    within '.answers' do
      expect(page).to have_content t('simple_form.options.start_form.answer.smell_gas')
      expect(page).to have_content t('simple_form.options.start_form.answer.no_heating')
      expect(page).to have_content t('simple_form.options.start_form.answer.no_water')
      expect(page).to have_content t('simple_form.options.start_form.answer.no_power')
      expect(page).to have_content t('simple_form.options.start_form.answer.water_leak')
      expect(page).to have_content t('simple_form.options.start_form.answer.home_adaptations')
      expect(page).to have_content t('simple_form.options.start_form.answer.none_of_the_above')
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

  scenario "Users can choose 'I smell gas' and get shown the relevant content" do
    visit '/questions/start/'
    choose_radio_button t('simple_form.options.start_form.answer.smell_gas')
    click_continue

    expect(page).to have_content 'What to do if you smell gas'
  end

  scenario "Users can choose 'No...' and is shown the next question" do
    visit '/questions/start/'
    choose_radio_button t('simple_form.options.start_form.answer.none_of_the_above')
    click_continue

    within '.question' do
      expect(page).to have_content 'In which room is the problem located?'
    end
  end

  private

  def click_continue
    click_button t('helpers.submit.create')
  end
end
