require 'rails_helper'

RSpec.feature 'Resident can locate a problem' do
  scenario 'when they are a Hackney Council Tenant' do
    properties = [
      { 'property_reference' => 'abc123', 'short_address' => 'Flat 1, 8 Hoxton Square, N1 6NU' },
    ]
    fake_api = double(list_properties: properties)
    allow(HackneyApi).to receive(:new).and_return(fake_api)

    visit '/address_search/'

    fill_in :address_search_postcode, with: 'N1 6NU'
    click_button t('helpers.submit.address_search.create')

    within '#address-search-results' do
      choose 'Flat 1, 8 Hoxton Square, N1 6NU'
    end

    click_button t('helpers.submit.address.create')

    expect(page).to have_content t('appointments.new.title')

    within '#progress' do
      expect(page).to have_content 'Flat 1, 8 Hoxton Square, N1 6NU'
    end
  end
end
