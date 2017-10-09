require 'rails_helper'

RSpec.feature 'Users cannot submit incomplete forms' do
  scenario 'they are shown the form again, with errors highlighted' do
    matching_property = {
      'property_reference' => 'zzz',
      'short_address' => '8A Abersham Road',
    }

    fake_api = instance_double(JsonApi)
    allow(fake_api).to receive(:get).with('properties?postcode=E5 8TE').and_return([matching_property])
    allow(fake_api).to receive(:get).with('properties/zzz').and_return(matching_property)
    allow(JsonApi).to receive(:new).and_return(fake_api)

    visit '/'

    # Start page
    click_on 'Start'

    # Emergency repairs
    choose_radio_button 'No'
    click_continue

    # Problem description
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
