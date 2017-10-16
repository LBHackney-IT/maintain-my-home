require 'rails_helper'

RSpec.feature 'Resident can navigate back' do
  scenario 'when the repair was diagnosed' do
    property = {
      'property_reference' => 'abc123',
      'short_address' => 'Flat 1, 8 Hoxton Square, N1 6NU',
    }
    fake_api = instance_double(JsonApi)
    allow(fake_api).to receive(:get).with('properties?postcode=E8 5TQ').and_return([property])
    allow(fake_api).to receive(:get).with('properties/abc123').and_return(property)
    allow(JsonApi).to receive(:new).and_return(fake_api)

    stub_diagnosis_question(answers: [{ 'text' => 'diagnose', 'sor_code' => '12345678' }])

    visit '/'
    click_on 'Start'

    # Emergency page:
    choose_radio_button 'No'
    click_on 'Continue'

    # Fake decision tree
    choose_radio_button 'diagnose'
    click_continue

    # Describe repair
    click_continue

    # Address search:
    fill_in 'Postcode', with: 'E8 5TQ'
    click_on 'Find my address'

    # Address selection:
    choose_radio_button 'Flat 1, 8 Hoxton Square, N1 6NU'
    click_on 'Continue'

    # Contact details
    click_on t('back_link')
    expect(page).to have_content 'What is your address?'
    click_on t('back_link')

    expect(page).to have_content 'Is there anything else we should know?'
    click_on t('back_link')

    expect(page).to have_content 'Do any of the following apply to you:'
  end

  scenario 'when the repair could not be diagnosed' do
    property = {
      'property_reference' => 'abc123',
      'short_address' => 'Flat 1, 8 Hoxton Square, N1 6NU',
    }
    fake_api = instance_double(JsonApi)
    allow(fake_api).to receive(:get).with('properties?postcode=E8 5TQ').and_return([property])
    allow(fake_api).to receive(:get).with('properties/abc123').and_return(property)
    allow(JsonApi).to receive(:new).and_return(fake_api)

    stub_diagnosis_question(answers: [{ 'text' => 'skip' }])

    visit '/'
    click_on 'Start'

    # Emergency page:
    choose_radio_button 'No'
    click_on 'Continue'

    # Fake decision tree
    choose_radio_button 'skip'
    click_continue

    # Describe repair
    click_continue

    # Address search:
    fill_in 'Postcode', with: 'E8 5TQ'
    click_on 'Find my address'

    # Address selection:
    choose_radio_button 'Flat 1, 8 Hoxton Square, N1 6NU'
    click_on 'Continue'

    # Contact details with callback - last page before confirmation:
    click_on t('back_link')
    expect(page).to have_content 'What is your address?'

    click_on t('back_link')
    expect(page).to have_content 'Is there anything else we should know?'

    click_on t('back_link')
    expect(page).to have_content 'Do any of the following apply to you:'
  end

  scenario 'when the address search was invalid' do
    stub_diagnosis_question(answers: [{ 'text' => 'skip' }])

    visit '/'
    click_on 'Start'

    # Emergency page:
    choose_radio_button 'No'
    click_on 'Continue'

    # Fake decision tree
    choose_radio_button 'skip'
    click_continue

    # Describe repair
    click_continue

    # Address search:
    fill_in 'Postcode', with: ''
    click_on 'Find my address'

    click_on t('back_link')
    expect(page).to have_content 'Is there anything else we should know?'
  end

  scenario 'when the contact details values were invalid' do
    property = {
      'property_reference' => 'abc123',
      'short_address' => 'Flat 1, 8 Hoxton Square, N1 6NU',
    }
    fake_api = instance_double(JsonApi)
    allow(fake_api).to receive(:get).with('properties?postcode=E8 5TQ').and_return([property])
    allow(fake_api).to receive(:get).with('properties/abc123').and_return(property)
    allow(JsonApi).to receive(:new).and_return(fake_api)

    stub_diagnosis_question(answers: [{ 'text' => 'diagnose', 'sor_code' => '12345678' }])

    visit '/'
    click_on 'Start'

    # Emergency page:
    choose_radio_button 'No'
    click_on 'Continue'

    # Fake decision tree
    choose_radio_button 'diagnose'
    click_continue

    # Describe repair
    click_continue

    # Address search:
    fill_in 'Postcode', with: 'E8 5TQ'
    click_on 'Find my address'

    # Address selection:
    choose_radio_button 'Flat 1, 8 Hoxton Square, N1 6NU'
    click_on 'Continue'

    # Contact details - submit an empty form
    click_on 'Continue'

    click_on t('back_link')

    expect(page).to have_content 'What is your address?'
  end

  scenario 'when the contact details with callback values were invalid' do
    property = {
      'property_reference' => 'abc123',
      'short_address' => 'Flat 1, 8 Hoxton Square, N1 6NU',
    }
    fake_api = instance_double(JsonApi)
    allow(fake_api).to receive(:get).with('properties?postcode=E8 5TQ').and_return([property])
    allow(fake_api).to receive(:get).with('properties/abc123').and_return(property)
    allow(JsonApi).to receive(:new).and_return(fake_api)

    stub_diagnosis_question(answers: [{ 'text' => 'skip' }])

    visit '/'
    click_on 'Start'

    # Emergency page:
    choose_radio_button 'No'
    click_on 'Continue'

    # Fake decision tree
    choose_radio_button 'skip'
    click_continue

    # Describe repair
    click_continue

    # Address search:
    fill_in 'Postcode', with: 'E8 5TQ'
    click_on 'Find my address'

    # Address selection:
    choose_radio_button 'Flat 1, 8 Hoxton Square, N1 6NU'
    click_on 'Continue'

    # Contact details - submit an empty form
    click_on 'Continue'

    click_on t('back_link')
    expect(page).to have_content 'What is your address?'
  end

  scenario 'going back from the Emergency exit page' do
    visit '/'
    click_on 'Start'

    # Emergency page:
    choose_radio_button 'Yes'
    click_on 'Continue'

    click_on t('back_link')
    expect(page).to have_content 'Do any of the following apply to you:'
  end

  scenario 'going back from the My address is not here exit page' do
    property = {
      'property_reference' => 'abc123',
      'short_address' => 'Flat 1, 8 Hoxton Square, N1 6NU',
    }
    fake_api = instance_double(JsonApi)
    allow(fake_api).to receive(:get).with('properties?postcode=E8 5TQ').and_return([property])
    allow(JsonApi).to receive(:new).and_return(fake_api)

    stub_diagnosis_question(answers: [{ 'text' => 'skip' }])

    visit '/'
    click_on 'Start'

    # Emergency page:
    choose_radio_button 'No'
    click_on 'Continue'

    # Fake decision tree
    choose_radio_button 'skip'
    click_continue

    # Describe repair
    click_continue

    # Address search:
    fill_in 'Postcode', with: 'E8 5TQ'
    click_on 'Find my address'

    # Address selection:
    choose_radio_button "My address isn't here"
    click_on 'Continue'

    click_on t('back_link')
    expect(page).to have_content 'What is your address?'
  end

  scenario 'going back from the address selection page' do
    fake_api = instance_double(JsonApi)
    allow(fake_api).to receive(:get).with('properties?postcode=E8 5TQ').and_return([])
    allow(JsonApi).to receive(:new).and_return(fake_api)

    stub_diagnosis_question(answers: [{ 'text' => 'skip' }])

    visit '/'
    click_on 'Start'

    # Emergency page:
    choose_radio_button 'No'
    click_on 'Continue'

    # Fake decision tree
    choose_radio_button 'skip'
    click_continue

    # Describe repair
    click_continue

    # Address search:
    fill_in 'Postcode', with: 'E8 5TQ'
    click_on 'Find my address'

    # Address selection:
    click_on t('back_link')
    expect(page).to have_content 'Is there anything else we should know?'
  end

  private

  def click_continue
    click_button t('helpers.submit.create')
  end
end
