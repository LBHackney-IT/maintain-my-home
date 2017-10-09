require 'rails_helper'

RSpec.feature 'Resident can locate a problem' do
  scenario 'viewing the address search form' do
    visit '/address-search'

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

    visit '/address-search'

    fill_in :address_search_postcode, with: 'N1 6NU'
    click_button t('helpers.submit.address_search.create')

    within '#address-search-results' do
      choose_radio_button 'Flat 1, 8 Hoxton Square, N1 6NU'
    end

    click_button t('helpers.submit.create')

    expect(page).to have_content t('contact-details.title')

    within '#progress' do
      expect(page).to have_content 'Flat 1, 8 Hoxton Square, N1 6NU'
    end
  end

  scenario 'when the address search returned no results' do
    fake_api = instance_double(JsonApi)
    allow(fake_api).to receive(:get).with('properties?postcode=N1 6NU').and_return([])
    allow(JsonApi).to receive(:new).and_return(fake_api)

    visit '/address-search'

    fill_in :address_search_postcode, with: 'N1 6NU'
    click_button t('helpers.submit.address_search.create')

    within '#address-search-results' do
      expect(page).to have_content t('address_search.not_found')
    end
  end

  scenario 'when an invalid postcode is entered' do
    visit '/address-search'

    fill_in :address_search_postcode, with: 'NNN1 1AAA'
    click_button t('helpers.submit.address_search.create')

    expect(page).to have_content "Postcode doesn't seem to be valid"
  end

  scenario 'when no postcode is entered' do
    visit '/address-search'

    fill_in :address_search_postcode, with: '  '
    click_button t('helpers.submit.address_search.create')

    expect(page).to have_content "Postcode can't be blank"
  end

  scenario 'changing the postcode after searching' do
    fake_api = instance_double(JsonApi)
    allow(fake_api).to receive(:get).with('properties?postcode=N1 6AA').and_return([])
    allow(fake_api).to receive(:get).with('properties?postcode=N1 6NU').and_return([])
    allow(JsonApi).to receive(:new).and_return(fake_api)

    visit '/address-search'

    fill_in :address_search_postcode, with: 'N1 6AA'
    click_button t('helpers.submit.address_search.create')

    expect(page).to have_content('N1 6AA')

    click_link t('address_search.change')

    fill_in :address_search_postcode, with: 'N1 6NU'
    click_button t('helpers.submit.address_search.create')

    expect(page).to have_content('N1 6NU')
  end

  scenario 'performing a search and not selecting an address, prevents form submission', js: true do
    matching_property = {
      'property_reference' => 'abc123',
      'short_address' => 'Flat 1, 8 Hoxton Square, N1 6NU',
    }

    fake_api = instance_double(JsonApi)
    allow(fake_api).to receive(:get).with('properties?postcode=N1 6NU').and_return([matching_property])
    allow(JsonApi).to receive(:new).and_return(fake_api)

    visit '/address-search'

    fill_in :address_search_postcode, with: 'N1 6NU'
    click_button t('helpers.submit.address_search.create')

    expect(page).to have_no_button t('helpers.submit.address.create')

    within '#address-search-results' do
      choose_radio_button 'Flat 1, 8 Hoxton Square, N1 6NU'
    end

    expect(page).to have_button t('helpers.submit.create')
  end

  scenario 'performing a search and not selecting an address' do
    matching_property = {
      'property_reference' => 'abc123',
      'short_address' => 'Flat 1, 8 Hoxton Square, N1 6NU',
    }

    fake_api = instance_double(JsonApi)
    allow(fake_api).to receive(:get).with('properties?postcode=N1 6NU').and_return([matching_property])
    allow(JsonApi).to receive(:new).and_return(fake_api)

    visit '/address-search'

    fill_in :address_search_postcode, with: 'N1 6NU'
    click_button t('helpers.submit.address_search.create')
    click_button t('helpers.submit.create')

    within '.address_form_property_reference .error-message' do
      expect(page).to have_content t('errors.messages.blank')
    end
  end

  scenario "user's address isn't listed" do
    other_property = {
      'property_reference' => 'abc123',
      'short_address' => '99 Abersham Road',
    }

    fake_api = instance_double(JsonApi)
    allow(fake_api).to receive(:get).with('properties?postcode=N1 6NU').and_return([other_property])
    allow(JsonApi).to receive(:new).and_return(fake_api)

    visit '/address-search'

    fill_in :address_search_postcode, with: 'N1 6NU'
    click_button t('helpers.submit.address_search.create')

    within '#address-search-results' do
      choose_radio_button t('simple_form.options.address_form.property_reference.address_isnt_here')
    end

    click_button t('helpers.submit.create')

    expect(page).to have_content 'We cannot find your address'
  end
end
