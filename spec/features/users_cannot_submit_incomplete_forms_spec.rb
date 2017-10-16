require 'rails_helper'

RSpec.feature 'Users cannot submit incomplete forms' do
  scenario 'they are shown the form again, with errors highlighted' do
    matching_property = {
      'property_reference' => 'zzz',
      'short_address' => '8A Abersham Road',
      'postcode' => 'E5 8TE',
    }

    fake_api = instance_double(JsonApi)
    allow(fake_api).to receive(:get).with('properties?postcode=E5 8TE').and_return([matching_property])
    allow(fake_api).to receive(:get).with('properties/zzz').and_return(matching_property)
    allow(JsonApi).to receive(:new).and_return(fake_api)

    fake_question_set = instance_double(QuestionSet)
    allow(fake_question_set)
      .to receive(:find)
      .with('location')
      .and_return(
        Question.new(
          'question' => 'Dummy question',
          'answers' => [
            { 'text' => 'skip' },
          ],
        )
      )
    allow(QuestionSet).to receive(:new).and_return(fake_question_set)

    visit '/'

    # Start page
    click_on 'Start'

    # Emergency repairs
    choose_radio_button 'No'
    click_continue

    # Fake decision tree
    choose_radio_button 'skip'
    click_continue

    # Describe repair
    click_continue

    # Choose address
    fill_in :address_search_postcode, with: 'E5 8TE'
    click_button t('helpers.submit.address_search.create')
    choose_radio_button '8A Abersham Road'
    click_button t('helpers.submit.create')

    # Submit empty contact details form
    click_continue

    expect(page).to have_css('.form-group.form-group-error')

    within '.contact_details_form_full_name' do
      expect(page).to have_css('span.error-message')
      expect(page).to have_css('div input[aria-invalid=true]')
    end

    within '.contact_details_form_telephone_number' do
      expect(page).to have_css('span.error-message')
      expect(page).to have_css('div input[aria-invalid=true]')
    end

    within '.contact_details_form_callback_time' do
      expect(page).to have_css('span.error-message')
      expect(page).to have_css('div input[aria-invalid=true]')
    end
  end

  private

  def click_continue
    click_button t('helpers.submit.create')
  end
end
