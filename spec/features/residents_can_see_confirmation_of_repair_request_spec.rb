require 'rails_helper'

RSpec.feature 'Resident can see a confirmation of their repair request' do
  scenario 'when the issue was diagnosed and an appointment was booked' do
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
        'workOrderReference' => '09124578',
        'priority' => 'N',
        'problem' => 'My sink is blocked',
        'propertyRef' => '00000503',
      )
    allow(JsonApi).to receive(:new).and_return(fake_api)

    fake_question_set = instance_double(QuestionSet)
    allow(fake_question_set)
      .to receive(:find)
      .with('location')
      .and_return(
        Question.new(
          'question' => 'Where is the problem?',
          'answers' => [
            { 'text' => 'Kitchen', 'next' => 'kitchen' },
            { 'text' => 'Bathroom' },
            { 'text' => 'Other' },
          ],
        )
      )
    allow(fake_question_set)
      .to receive(:find)
      .with('kitchen')
      .and_return(
        Question.new(
          'question' => 'Is your tap broken?',
          'answers' => [
            { 'text' => 'Yes', 'sor_code' => '0078965' },
            { 'text' => 'No' },
          ],
        )
      )
    allow(QuestionSet).to receive(:new).and_return(fake_question_set)

    visit '/'
    click_on 'Start'

    # Emergency page:
    choose_radio_button 'No'
    click_on 'Continue'

    # Fake decision tree
    choose_radio_button 'Kitchen'
    click_on 'Continue'

    choose_radio_button 'Yes'
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
    click_on 'Continue'

    aggregate_failures do
      within '#confirmation' do
        expect(page).to have_content 'Your reference number is 09124578'
      end

      within '#summary' do
        expect(page).to have_content t('confirmation.summary.description', description: 'My sink is blocked')

        expect(page).to have_content t('confirmation.summary.name', name: 'John Evans')
        expect(page).to have_content t('confirmation.summary.phone', phone: '07898765432')
        expect(page).to have_content t('confirmation.summary.address', address: 'Ross Court 23, E5 8TE')
      end
    end

    expect(fake_api).to have_received(:post).with(
      'repairs',
      priority: 'N',
      problem: 'My sink is blocked',
      propertyRef: '00000503',
      repairOrders: [
        { jobCode: '0078965', propertyReference: '00000503' },
      ]
    )
  end

  scenario 'when the issue could not be completely diagnosed (and a callback is required)' do
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

    stub_one_diagnosis_question(answers: [{ 'text' => 'skip' }])

    visit '/'
    click_on 'Start'

    # Emergency page:
    choose_radio_button 'No'
    click_on 'Continue'

    # Fake decision tree
    choose_radio_button 'skip'
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
