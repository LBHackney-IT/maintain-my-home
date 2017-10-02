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
    click_on 'Back to address search'
    expect(page).to have_content 'What is your address?'

    click_on 'Back to problem details'
    expect(page).to have_content 'Is there anything else we should know about this problem?'

    click_on 'Back to start'
    expect(page).to have_content 'Is your problem one of these?'
  end

  scenario 'going back from both address pages (search and selection)'
  scenario 'going back after validation errors'
  scenario 'going back from the describe unknown repair page'
  scenario 'going back TO the describe unknown repair page'
  scenario 'going back from the Emergency exit page'
  scenario 'going back from the My address is not here exit page'
end
