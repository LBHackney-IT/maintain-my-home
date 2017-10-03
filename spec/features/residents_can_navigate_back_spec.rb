require 'rails_helper'

RSpec.feature 'Resident can navigate back' do
  scenario 'taking a full happy path through the forms' do
    property = {
      'property_reference' => 'abc123',
      'short_address' => 'Flat 1, 8 Hoxton Square, N1 6NU',
    }
    fake_api = instance_double(JsonApi)
    allow(fake_api).to receive(:get).with('properties?postcode=E8 5TQ').and_return([property])
    allow(fake_api).to receive(:get).with('properties/abc123').and_return(property)
    allow(JsonApi).to receive(:new).and_return(fake_api)

    visit '/'
    click_on 'Start'

    # Emergency page:
    choose_radio_button 'No'
    click_on 'Continue'

    # Describe problem:
    click_on 'Continue'

    # Address search:
    fill_in 'Postcode', with: 'E8 5TQ'
    click_on 'Find my address'

    # Address selection:
    choose_radio_button 'Flat 1, 8 Hoxton Square, N1 6NU'
    click_on 'Continue'

    # Contact details - last page before confirmation:
    click_on t('back_links.address_searches')
    expect(page).to have_content 'What is your address?'

    click_on t('back_links.describe_repair')
    expect(page).to have_content 'Is there anything else we should know about this problem?'

    click_on t('back_links.questions/start')
    expect(page).to have_content 'Is your problem one of these?'
  end

  scenario 'when the address search was invalid' do
    visit '/'
    click_on 'Start'

    # Emergency page:
    choose_radio_button 'No'
    click_on 'Continue'

    # Describe problem:
    click_on 'Continue'

    # Address search:
    fill_in 'Postcode', with: ''
    click_on 'Find my address'

    click_on t('back_links.describe_repair')
    expect(page).to have_content 'Is there anything else we should know about this problem?'
  end

  scenario 'when the contact details search was invalid' do
    property = {
      'property_reference' => 'abc123',
      'short_address' => 'Flat 1, 8 Hoxton Square, N1 6NU',
    }
    fake_api = instance_double(JsonApi)
    allow(fake_api).to receive(:get).with('properties?postcode=E8 5TQ').and_return([property])
    allow(fake_api).to receive(:get).with('properties/abc123').and_return(property)
    allow(JsonApi).to receive(:new).and_return(fake_api)

    visit '/'
    click_on 'Start'

    # Emergency page:
    choose_radio_button 'No'
    click_on 'Continue'

    # Describe problem:
    click_on 'Continue'

    # Address search:
    fill_in 'Postcode', with: 'E8 5TQ'
    click_on 'Find my address'

    # Address selection:
    choose_radio_button 'Flat 1, 8 Hoxton Square, N1 6NU'
    click_on 'Continue'

    # Contact details - submit an empty form
    click_on 'Continue'

    click_on t('back_links.address_searches')
    expect(page).to have_content 'What is your address?'
  end

  scenario 'going back from the Emergency exit page' do
    visit '/'
    click_on 'Start'

    # Emergency page:
    choose_radio_button 'Yes'
    click_on 'Continue'

    click_on t('back_links.questions/start')
    expect(page).to have_content 'Is your problem one of these?'
  end

  scenario 'going back from the My address is not here exit page' do
    property = {
      'property_reference' => 'abc123',
      'short_address' => 'Flat 1, 8 Hoxton Square, N1 6NU',
    }
    fake_api = instance_double(JsonApi)
    allow(fake_api).to receive(:get).with('properties?postcode=E8 5TQ').and_return([property])
    allow(JsonApi).to receive(:new).and_return(fake_api)

    visit '/'
    click_on 'Start'

    # Emergency page:
    choose_radio_button 'No'
    click_on 'Continue'

    # Describe problem:
    click_on 'Continue'

    # Address search:
    fill_in 'Postcode', with: 'E8 5TQ'
    click_on 'Find my address'

    # Address selection:
    choose_radio_button "My address isn't here"
    click_on 'Continue'

    click_on t('back_links.address_searches')
    expect(page).to have_content 'What is your address?'
  end

  scenario 'going back from both address pages (search and selection)'
  scenario 'going back from the describe unknown repair page'
  scenario 'going back TO the describe unknown repair page'
end
