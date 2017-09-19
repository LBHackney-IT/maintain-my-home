require 'rails_helper'

RSpec.feature 'Resident can locate a problem' do
  scenario 'viewing the address search form' do
    visit '/address_search/'

    expect(page).to have_no_css('#address-search-results')
  end

  scenario 'when they are a Hackney Council Tenant' do
    tenant_property = {
      'property_reference' => 'abc123',
      'short_address' => 'Flat 1, 8 Hoxton Square, N1 6NU',
    }
    other_property = {
      'property_reference' => 'def456',
      'short_address' => 'Flat 7, 12 Hoxton Square, N1 6NU',
    }

    matching_properties = [other_property, tenant_property]

    fake_api = instance_double(JsonApi)
    allow(fake_api).to receive(:get).with('properties?postcode=N1 6NU').and_return(matching_properties)
    allow(fake_api).to receive(:get).with('properties/abc123').and_return(tenant_property)
    allow(JsonApi).to receive(:new).and_return(fake_api)

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

  scenario "when the address couldn't be found" do
    fake_api = instance_double(JsonApi)
    allow(fake_api).to receive(:get).with('properties?postcode=N1 6NU').and_return([])
    allow(JsonApi).to receive(:new).and_return(fake_api)

    visit '/address_search/'

    fill_in :address_search_postcode, with: 'N1 6NU'
    click_button t('helpers.submit.address_search.create')

    within '#address-search-results' do
      expect(page).to have_content t('address_search.not_found')
    end
  end

  scenario 'when an invalid postcode is entered' do
    visit '/address_search/'

    fill_in :address_search_postcode, with: 'NNN1 1AAA'
    click_button t('helpers.submit.address_search.create')

    expect(page).to have_content "Postcode doesn't seem to be valid"
  end

  scenario 'when no postcode is entered' do
    visit '/address_search/'

    fill_in :address_search_postcode, with: '  '
    click_button t('helpers.submit.address_search.create')

    expect(page).to have_content "Postcode can't be blank"
  end

  scenario 'changing the postcode after searching' do
    visit '/address_search/'

    fill_in :address_search_postcode, with: 'N1 6AA'
    click_button t('helpers.submit.address_search.create')

    expect(page).to have_content('N1 6AA')

    click_button t('address_search.change')

    fill_in :address_search_postcode, with: 'N1 6NU'
    click_button t('helpers.submit.address_search.create')

    expect(page).to have_content('N1 6NU')
  end
end
