require 'rails_helper'

RSpec.feature 'Resident can see a confirmation of their repair request' do
  scenario 'when the repair request creation was successful' do
    property = {
      'property_reference' => '00000503',
      'short_address' => 'Ross Court 30',
      'postcode' => 'E5 8TE',
    }
    fake_api = instance_double(JsonApi)
    allow(fake_api).to receive(:get).with('properties?postcode=E5 8TE').and_return([property])
    allow(fake_api).to receive(:get).with('properties/00000503').and_return(property)
    allow(JsonApi).to receive(:new).and_return(fake_api)

    visit '/'
    click_on 'Start'

    # Emergency page:
    choose_radio_button 'No'
    click_on 'Continue'

    # Describe problem:
    fill_in 'dummy_form_description', with: "The bath won't drain"
    click_on 'Continue'

    # Address search:
    fill_in 'Postcode', with: 'E5 8TE'
    click_on 'Find my address'

    # Address selection:
    choose_radio_button 'Ross Court 30'
    click_on 'Continue'

    # Contact details - last page before confirmation:
    fill_in 'Full name', with: 'John Smith'
    fill_in 'Telephone number', with: '01234567890'
    check 'afternoon (12pm - 5pm)'
    click_on 'Continue'

    expect(page).to have_content 'Your reference number is abc123'

    expect(page).to have_content t('confirmation.summary.description', description: "The bath won't drain")

    expect(page).to have_content t('confirmation.summary.name', name: 'John Smith')
    expect(page).to have_content t('confirmation.summary.phone', phone: '01234 567 890')
    expect(page).to have_content t('confirmation.summary.address', address: 'Ross Court 30, E5 8TE')

    expect(page).to have_content t('confirmation.summary.time', time: 'afternoon (12pm - 5pm)')
  end
end
