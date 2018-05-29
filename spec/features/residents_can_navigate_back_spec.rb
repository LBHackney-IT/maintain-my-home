require 'rails_helper'

RSpec.feature 'Resident can navigate back', js: true do
  scenario 'when the repair was diagnosed' do
    property = {
      'propertyReference' => 'abc123',
      'address' => 'Flat 1, 8 Hoxton Square',
      'postcode' => 'N1 6NU',
    }
    fake_api = instance_double(JsonApi)
    allow(fake_api).to receive(:get).with('hackneyrepairs/v1/properties?postcode=E8 5TQ').and_return('results' => [property])
    allow(fake_api).to receive(:get).with('hackneyrepairs/v1/properties/abc123').and_return(property)
    allow(JsonApi).to receive(:new).and_return(fake_api)

    stub_diagnosis_question(question: 'What is the problem?', answers: [{ 'text' => 'diagnose', 'sor_code' => '12345678' }])

    visit '/'
    click_on 'Start'

    # Emergency page:
    choose_radio_button 'No'
    click_on 'Continue'

    # Filter page:
    choose_radio_button 'No'
    click_on 'Continue'

    # Fake decision tree
    choose_radio_button 'diagnose'
    click_continue

    # Describe repair
    fill_in 'Description', with: 'My bathroom widget is broken'
    click_continue

    # Address search:
    fill_in 'Postcode', with: 'E8 5TQ'
    click_on 'Find my address'

    # Address selection:
    choose_radio_button 'Flat 1, 8 Hoxton Square'
    click_on 'Continue'

    # Contact details
    click_on t('back_link')

    # Address selection:
    expect(page).to have_content 'What is your address?'
    click_on t('back_link')

    # Address confirmation:
    expect(page).to have_content 'Confirm address'
    expect(page).to have_content 'Flat 1, 8 Hoxton Square'
    click_on t('back_link')

    expect(page).to have_content 'Let us know any further details'
    click_on t('back_link')

    expect(page).to have_content 'What is the problem?'
    click_on t('back_link')

    expect(page).to have_content 'Do any of the following apply'
  end

  scenario 'when the repair could not be diagnosed' do
    property = {
      'propertyReference' => 'abc123',
      'address' => 'Flat 1, 8 Hoxton Square',
      'postcode' => 'N1 6NU',
    }
    fake_api = instance_double(JsonApi)
    allow(fake_api).to receive(:get).with('hackneyrepairs/v1/properties?postcode=E8 5TQ').and_return('results' => [property])
    allow(fake_api).to receive(:get).with('hackneyrepairs/v1/properties/abc123').and_return(property)
    allow(JsonApi).to receive(:new).and_return(fake_api)

    stub_diagnosis_question(question: 'What is the problem?', answers: [{ 'text' => 'skip' }])

    visit '/'
    click_on 'Start'

    # Emergency page:
    choose_radio_button 'No'
    click_on 'Continue'

    # Filter page:
    choose_radio_button 'No'
    click_on 'Continue'

    # Fake decision tree
    choose_radio_button 'skip'
    click_continue

    # Describe repair
    fill_in 'Problem description', with: 'Things are broken'
    click_continue

    # Address search:
    fill_in 'Postcode', with: 'E8 5TQ'
    click_on 'Find my address'

    # Address selection:
    choose_radio_button 'Flat 1, 8 Hoxton Square'
    click_on 'Continue'

    # Contact details with callback - last page before confirmation:
    click_on t('back_link')

    # Address selection:
    expect(page).to have_content 'What is your address?'
    click_on t('back_link')

    # Address confirmation:
    expect(page).to have_content 'Confirm address'
    expect(page).to have_content 'Flat 1, 8 Hoxton Square'
    click_on t('back_link')

    expect(page).to have_content 'Let us know any further details you think might help us'
    click_on t('back_link')

    expect(page).to have_content 'What is the problem?'
    click_on t('back_link')

    expect(page).to have_content 'Do any of the following apply'
  end

  scenario 'when the address search was invalid' do
    stub_diagnosis_question(answers: [{ 'text' => 'skip' }])

    visit '/'
    click_on 'Start'

    # Emergency page:
    choose_radio_button 'No'
    click_on 'Continue'

    # Filter page:
    choose_radio_button 'No'
    click_on 'Continue'

    # Fake decision tree
    choose_radio_button 'skip'
    click_continue

    # Describe repair
    fill_in 'Problem description', with: 'Things are broken'
    click_continue

    # Address search:
    fill_in 'Postcode', with: ''
    click_on 'Find my address'

    # Address search (validation error):
    click_on t('back_link')

    # Address search (no validation error):
    expect(page).to have_content 'What is your address?'
    click_on t('back_link')

    expect(page).to have_content 'Let us know any further details you think might help us'
  end

  scenario 'when the contact details values were invalid' do
    property = {
      'propertyReference' => 'abc123',
      'address' => 'Flat 1, 8 Hoxton Square',
      'postcode' => 'N1 6NU',
    }
    fake_api = instance_double(JsonApi)
    allow(fake_api).to receive(:get).with('hackneyrepairs/v1/properties?postcode=E8 5TQ').and_return('results' => [property])
    allow(fake_api).to receive(:get).with('hackneyrepairs/v1/properties/abc123').and_return(property)
    allow(JsonApi).to receive(:new).and_return(fake_api)

    stub_diagnosis_question(answers: [{ 'text' => 'diagnose', 'sor_code' => '12345678' }])

    visit '/'
    click_on 'Start'

    # Emergency page:
    choose_radio_button 'No'
    click_on 'Continue'

    # Filter page:
    choose_radio_button 'No'
    click_on 'Continue'

    # Fake decision tree
    choose_radio_button 'diagnose'
    click_continue

    # Describe repair
    fill_in 'Description', with: 'My bathroom widget is broken'
    click_continue

    # Address search:
    fill_in 'Postcode', with: 'E8 5TQ'
    click_on 'Find my address'

    # Address selection:
    choose_radio_button 'Flat 1, 8 Hoxton Square'
    click_on 'Continue'

    # Contact details - submit an empty form
    click_on 'Continue'

    # Contact details with validation error:
    click_on t('back_link')

    # Contact details without validation error:
    click_on t('back_link')

    expect(page).to have_content 'What is your address?'
  end

  scenario 'when the contact details with callback values were invalid' do
    property = {
      'propertyReference' => 'abc123',
      'address' => 'Flat 1, 8 Hoxton Square',
      'postcode' => 'N1 6NU',
    }
    fake_api = instance_double(JsonApi)
    allow(fake_api).to receive(:get).with('hackneyrepairs/v1/properties?postcode=E8 5TQ').and_return('results' => [property])
    allow(fake_api).to receive(:get).with('hackneyrepairs/v1/properties/abc123').and_return(property)
    allow(JsonApi).to receive(:new).and_return(fake_api)

    stub_diagnosis_question(answers: [{ 'text' => 'skip' }])

    visit '/'
    click_on 'Start'

    # Emergency page:
    choose_radio_button 'No'
    click_on 'Continue'

    # Filter page:
    choose_radio_button 'No'
    click_on 'Continue'

    # Fake decision tree
    choose_radio_button 'skip'
    click_continue

    # Describe repair
    fill_in 'Problem description', with: 'Things are broken'
    click_continue

    # Address search:
    fill_in 'Postcode', with: 'E8 5TQ'
    click_on 'Find my address'

    # Address selection:
    choose_radio_button 'Flat 1, 8 Hoxton Square'
    click_on 'Continue'

    # Contact details - submit an empty form
    click_on 'Continue'

    # Contact details with validation error:
    click_on t('back_link')

    # Contact details without validation error:
    click_on t('back_link')

    expect(page).to have_content 'What is your address?'
  end

  scenario 'going back from the Emergency exit page' do
    visit '/'
    click_on 'Start'

    # Emergency page:
    choose_radio_button 'I can smell gas'
    click_on 'Continue'

    click_on t('back_link')
    expect(page).to have_content 'Do any of the following apply'
  end

  scenario 'going back from the My address is not here exit page' do
    property = {
      'propertyReference' => 'abc123',
      'address' => 'Flat 1, 8 Hoxton Square',
      'postcode' => 'N1 6NU',
    }
    fake_api = instance_double(JsonApi)
    allow(fake_api).to receive(:get).with('hackneyrepairs/v1/properties?postcode=E8 5TQ').and_return('results' => [property])
    allow(JsonApi).to receive(:new).and_return(fake_api)

    stub_diagnosis_question(answers: [{ 'text' => 'skip' }])

    visit '/'
    click_on 'Start'

    # Emergency page:
    choose_radio_button 'No'
    click_on 'Continue'

    # Filter page:
    choose_radio_button 'No'
    click_on 'Continue'

    # Fake decision tree
    choose_radio_button 'skip'
    click_continue

    # Describe repair
    fill_in 'Problem description', with: 'Things are broken'
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
    allow(fake_api).to receive(:get).with('hackneyrepairs/v1/properties?postcode=E8 5TQ').and_return('results' => [])
    allow(JsonApi).to receive(:new).and_return(fake_api)

    stub_diagnosis_question(answers: [{ 'text' => 'skip' }])

    visit '/'
    click_on 'Start'

    # Emergency page:
    choose_radio_button 'No'
    click_on 'Continue'

    # Filter page:
    choose_radio_button 'No'
    click_on 'Continue'

    # Fake decision tree
    choose_radio_button 'skip'
    click_continue

    # Describe repair
    fill_in 'Problem description', with: 'Things are broken'
    click_continue

    # Address search:
    fill_in 'Postcode', with: 'E8 5TQ'
    click_on 'Find my address'

    # Address selection:
    click_on t('back_link')

    # Address search:
    click_on t('back_link')

    expect(page).to have_content 'Let us know any further details you think might help us'
  end

  private

  def click_continue
    click_button t('helpers.submit.create')
  end
end
