require 'rails_helper'

RSpec.feature 'Resident can see a confirmation of their repair request' do
  scenario 'when the issue was diagnosed and an appointment was booked' do
    property = {
      'propertyReference' => '00000503',
      'address' => 'Ross Court 23',
      'postcode' => 'E5 8TE',
    }
    fake_api = instance_double(JsonApi)
    allow(fake_api).to receive(:get).with('v1/properties?postcode=E5 8TE').and_return('results' => [property])
    allow(fake_api).to receive(:get).with('v1/properties/00000503').and_return(property)
    allow(fake_api).to receive(:post)
      .with('repairs', anything)
      .and_return(
        'repairRequestReference' => '00367923',
        'orderReference' => '09124578',
        'priority' => 'N',
        'problem' => "My sink is blocked\n\nRoom: Kitchen",
        'propertyReference' => '00000503',
      )
    allow(fake_api).to receive(:get)
      .with('repairs/00367923')
      .and_return(
        'repairRequestReference' => '00367923',
        'orderReference' => '09124578',
        'priority' => 'N',
        'problem' => "My sink is blocked\n\nRoom: Kitchen",
        'propertyReference' => '00000503',
      )
    allow(fake_api).to receive(:get)
      .with('work_orders/09124578/appointments')
      .and_return(
        [
          { 'beginDate' => '2017-10-11T10:00:00Z', 'endDate' => '2017-10-11T12:00:00Z', 'bestSlot' => false },
          { 'beginDate' => '2017-10-11T12:00:00Z', 'endDate' => '2017-10-11T17:00:00Z', 'bestSlot' => false },
        ]
      )
    allow(fake_api).to receive(:post)
      .with(
        'work_orders/09124578/appointments',
        beginDate: '2017-10-11T12:00:00Z',
        endDate: '2017-10-11T17:00:00Z',
      )
      .and_return(
        'beginDate' => '2017-10-11T12:00:00Z',
        'endDate' => '2017-10-11T17:00:00Z',
        'status' => 'booked',
      )
    allow(JsonApi).to receive(:new).and_return(fake_api)

    fake_question_set = instance_double(QuestionSet)
    allow(fake_question_set)
      .to receive(:find)
      .with('location')
      .and_return(
        Question.new(
          'id' => 'location',
          'question' => 'Where is the problem located?',
          'answers' => [
            { 'text' => 'Inside', 'next' => 'which_room' },
            { 'text' => 'Outside' },
          ],
        )
      )
    allow(fake_question_set)
      .to receive(:find)
      .with('which_room')
      .and_return(
        Question.new(
          'id' => 'which_room',
          'question' => 'Which room?',
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
          'id' => 'kitchen',
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
    choose_radio_button 'Inside'
    click_on 'Continue'
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

    # Contact details:
    fill_in 'Full name', with: 'John Evans'
    fill_in 'Telephone number', with: '078 98765 432'
    click_on 'Continue'

    # Appointments:
    choose_radio_button 'Wednesday 12pm-5pm (11th October)'
    click_on 'Continue'

    aggregate_failures do
      within '#confirmation' do
        expect(page).to have_content 'Your reference number is 09124578'
        expect(page).to have_content 'Wednesday 11th October'
        expect(page).to have_content 'between 12pm and 5pm'
      end

      within '#summary' do
        expect(page).to have_content t('confirmation.summary.room', room: 'Kitchen')
        expect(page).to have_content t('confirmation.summary.description', description: 'My sink is blocked')

        expect(page).to have_content t('confirmation.summary.name', name: 'John Evans')
        expect(page).to have_content t('confirmation.summary.phone', phone: '07898765432')
        expect(page).to have_content t('confirmation.summary.address', address: 'Ross Court 23, E5 8TE')
      end
    end

    expect(fake_api).to have_received(:post).with(
      'repairs',
      priority: 'N',
      problemDescription: "My sink is blocked\n\nRoom: Kitchen",
      propertyReference: '00000503',
      contact: {
        name: 'John Evans',
        telephoneNumber: '078 98765 432',
      },
      workOrders: [
        { sorCode: '0078965' },
      ]
    )

    expect(fake_api).to have_received(:post).with(
      'work_orders/09124578/appointments',
      beginDate: '2017-10-11T12:00:00Z',
      endDate: '2017-10-11T17:00:00Z',
    )
  end

  scenario 'when the issue could not be completely diagnosed (and a callback is required)' do
    property = {
      'propertyReference' => '00000503',
      'address' => 'Ross Court 23',
      'postcode' => 'E5 8TE',
    }
    fake_api = instance_double(JsonApi)
    allow(fake_api).to receive(:get).with('v1/properties?postcode=E5 8TE').and_return('results' => [property])
    allow(fake_api).to receive(:get).with('v1/properties/00000503').and_return(property)
    allow(fake_api).to receive(:post)
      .with('repairs', anything)
      .and_return(
        'repairRequestReference' => '00367923',
        'priority' => 'N',
        'problem' => "My sink is blocked\n\nRoom: Other",
        'propertyReference' => '00000503',
      )
    allow(fake_api).to receive(:get)
      .with('repairs/00367923')
      .and_return(
        'repairRequestReference' => '00367923',
        'priority' => 'N',
        'problem' => "My sink is blocked\n\nRoom: Other",
        'propertyReference' => '00000503',
      )
    allow(JsonApi).to receive(:new).and_return(fake_api)

    fake_question_set = instance_double(QuestionSet)
    allow(fake_question_set)
      .to receive(:find)
      .with('location')
      .and_return(
        Question.new(
          'id' => 'location',
          'question' => 'Where is the problem located?',
          'answers' => [
            { 'text' => 'Inside', 'next' => 'which_room' },
            { 'text' => 'Outside' },
          ],
        )
      )
    allow(fake_question_set)
      .to receive(:find)
      .with('which_room')
      .and_return(
        Question.new(
          'id' => 'which_room',
          'question' => 'Which room?',
          'answers' => [
            { 'text' => 'Kitchen', 'next' => 'kitchen' },
            { 'text' => 'Bathroom' },
            { 'text' => 'Other' },
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
    choose_radio_button 'Inside'
    click_on 'Continue'
    choose_radio_button 'Other'
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
    check 'afternoon (12pm - 5pm)'
    click_on 'Continue'

    aggregate_failures do
      within '#confirmation' do
        expect(page).to have_content 'Your reference number is 00367923'
        expect(page).to have_content 'between 8am and 5pm'
      end

      within '#summary' do
        expect(page).to have_content t('confirmation.summary.room', room: 'Other')
        expect(page).to have_content t('confirmation.summary.description', description: 'My sink is blocked')

        expect(page).to have_content t('confirmation.summary.name', name: 'John Evans')
        expect(page).to have_content t('confirmation.summary.phone', phone: '07898765432')
        expect(page).to have_content t('confirmation.summary.address', address: 'Ross Court 23, E5 8TE')
      end
    end

    expect(fake_api).to have_received(:post).with(
      'repairs',
      priority: 'N',
      problemDescription: "My sink is blocked\n\nRoom: Other\n\nCallback requested: between 8am and 5pm",
      propertyReference: '00000503',
      contact: {
        name: 'John Evans',
        telephoneNumber: '078 98765 432',
      },
    )
  end

  scenario 'when the issue was in a communal area' do
    property = {
      'propertyReference' => '00000503',
      'address' => 'Ross Court 23',
      'postcode' => 'E5 8TE',
    }
    fake_api = instance_double(JsonApi)
    allow(fake_api).to receive(:get).with('v1/properties?postcode=E5 8TE').and_return('results' => [property])
    allow(fake_api).to receive(:get).with('v1/properties/00000503').and_return(property)
    allow(fake_api).to receive(:post)
      .with('repairs', anything)
      .and_return(
        'repairRequestReference' => '00367923',
        'priority' => 'N',
        'problem' => "The streetlamp is broken\n\nCallback requested: between 8am and 12pm",
        'propertyReference' => '00000503',
      )
    allow(fake_api).to receive(:get)
      .with('repairs/00367923')
      .and_return(
        'repairRequestReference' => '00367923',
        'priority' => 'N',
        'problem' => "The streetlamp is broken\n\nCallback requested: between 8am and 12pm",
        'propertyReference' => '00000503',
      )
    allow(JsonApi).to receive(:new).and_return(fake_api)

    fake_question_set = instance_double(QuestionSet)
    allow(fake_question_set)
      .to receive(:find)
      .with('location')
      .and_return(
        Question.new(
          'id' => 'location',
          'question' => 'Where is the problem located?',
          'answers' => [
            { 'text' => 'Inside', 'next' => 'which_room' },
            { 'text' => 'Outside' },
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
    choose_radio_button 'Outside'
    click_on 'Continue'

    # Describe problem:
    fill_in 'describe_repair_form_description', with: 'The streetlamp is broken'
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
        expect(page).to_not have_content t('confirmation.summary.room', room: '')
        expect(page).to have_content t('confirmation.summary.description', description: 'The streetlamp is broken')

        expect(page).to have_content t('confirmation.summary.name', name: 'John Evans')
        expect(page).to have_content t('confirmation.summary.phone', phone: '07898765432')
        expect(page).to have_content t('confirmation.summary.address', address: 'Ross Court 23, E5 8TE')
      end
    end

    expect(fake_api).to have_received(:post).with(
      'repairs',
      priority: 'N',
      problemDescription: "The streetlamp is broken\n\nCallback requested: between 8am and 12pm",
      propertyReference: '00000503',
      contact: {
        name: 'John Evans',
        telephoneNumber: '078 98765 432',
      },
    )
  end
end
