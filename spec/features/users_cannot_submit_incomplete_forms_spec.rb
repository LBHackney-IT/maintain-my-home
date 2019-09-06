require 'rails_helper'

RSpec.feature 'Users cannot submit incomplete forms' do
  scenario 'when the repair could not be diagnosed' do
    matching_property = {
      'propertyReference' => 'zzz',
      'address' => '8A Abersham Road',
      'postcode' => 'E5 8TE',
    }

    fake_api = instance_double(JsonApi)
    allow(fake_api).to receive(:get).with('repairs/v1/properties?postcode=E5 8TE').and_return('results' => [matching_property])
    allow(fake_api).to receive(:get).with('repairs/v1/properties/zzz').and_return(matching_property)
    allow(JsonApi).to receive(:new).and_return(fake_api)

    stub_diagnosis_question(answers: [{ 'text' => 'skip' }])

    visit '/'

    # Start page
    click_on 'Start'

    # Emergency repairs
    choose_radio_button 'No'
    click_continue

    # Filter page:
    choose_radio_button 'No'
    click_on 'Continue'

    # Fake decision tree
    choose_radio_button 'skip'
    click_continue

    # Describe repair
    fill_in 'Problem description', with: 'Things are broken'
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

  scenario 'when the repair was diagnosed' do
    matching_property = {
      'propertyReference' => 'zzz',
      'address' => '8A Abersham Road',
      'postcode' => 'E5 8TE',
    }

    fake_api = instance_double(JsonApi)
    allow(fake_api).to receive(:get).with('repairs/v1/properties?postcode=E5 8TE').and_return('results' => [matching_property])
    allow(fake_api).to receive(:get).with('repairs/v1/properties/zzz').and_return(matching_property)
    allow(fake_api).to receive(:get).with('repairs/v1/cautionary_contact/?reference=zzz')
      .and_return({'results'=>{'alertCodes'=>[nil], 'callerNotes'=>[nil]}})
    allow(JsonApi).to receive(:new).and_return(fake_api)

    stub_diagnosis_question(answers: [{ 'text' => 'diagnose', 'sor_code' => 'fake_code' }])

    visit '/'

    # Start page
    click_on 'Start'

    # Emergency repairs
    choose_radio_button 'No'
    click_continue

    # Filter page:
    choose_radio_button 'No'
    click_on 'Continue'

    # Fake decision tree
    choose_radio_button 'diagnose'
    click_continue

    # Describe repair
    fill_in 'Description', with: 'Things are broken'
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
  end

  private

  def click_continue
    click_button t('helpers.submit.create')
  end
end
