require 'rails_helper'

RSpec.feature 'Resident can see a confirmation of their repair request' do
  scenario 'when the repair request creation was successful' do
    property = {
      'property_reference' => '00000503',
      'short_address' => 'Ross Court 23',
      'postcode' => 'E5 8TE',
    }
    fake_api = instance_double(JsonApi)
    allow(fake_api).to receive(:get).with('properties?postcode=E5 8TE').and_return([property])
    allow(fake_api).to receive(:get).with('properties/00000503').and_return(property)
    allow(fake_api).to receive(:post)
      .with('repairs', anything)
      .and_return(
        'requestReference' => '00367923',
        'priority' => 'N',
        'problem' => 'My sink is blocked',
        'propertyRef' => '00000503',
      )
    allow(JsonApi).to receive(:new).and_return(fake_api)

    visit '/'
    click_on 'Start'

    # Emergency page:
    choose_radio_button 'No'
    click_on 'Continue'

    # Describe problem:
    fill_in 'describe_repair_form_description', with: 'My sink is blocked'
    click_on 'Continue'

    # Address search:
    fill_in 'Postcode', with: 'E5 8TE'
    click_on 'Find my address'

    # Address selection:
    choose_radio_button 'Ross Court 23'
    click_on 'Continue'

    # Contact details - last page before confirmation:
    fill_in 'Full name', with: 'John Evans'
    fill_in 'Telephone number', with: '078 98765 432'
    check 'morning (8am - 12pm)'
    click_on 'Continue'

    aggregate_failures do
      within '#confirmation' do
        expect(page).to have_content 'Your reference number is 00367923'
        expect(page).to have_content 'between 8am and 12pm'
      end

      within '#summary' do
        expect(page).to have_content t('confirmation.summary.description', description: 'My sink is blocked')

        expect(page).to have_content t('confirmation.summary.name', name: 'John Evans')
        expect(page).to have_content t('confirmation.summary.phone', phone: '07898765432')
        expect(page).to have_content t('confirmation.summary.address', address: 'Ross Court 23, E5 8TE')

        expect(page).to have_content t('confirmation.summary.callback_time', callback_time: 'between 8am and 12pm')
      end
    end

    expect(fake_api).to have_received(:post).with(
      'repairs',
      priority: 'N',
      problem: 'My sink is blocked',
      propertyRef: '00000503',
    )
  end
end
