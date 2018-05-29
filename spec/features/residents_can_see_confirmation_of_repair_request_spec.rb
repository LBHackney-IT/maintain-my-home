require 'rails_helper'

RSpec.feature 'Resident can see a confirmation of their repair request' do
  around(:each) do |example|
    travel_to Time.zone.local(2017, 10, 1) do
      example.run
    end
  end

  scenario 'when the issue was diagnosed and an appointment was booked' do
    ClimateControl.modify(ENCRYPTION_SECRET: 'test') do
      property = {
        'propertyReference' => '00000503',
        'address' => 'Ross Court 23',
        'postcode' => 'E5 8TE',
      }
      fake_api = instance_double(JsonApi)
      allow(fake_api).to receive(:get).with('hackneyrepairs/v1/properties?postcode=E5 8TE').and_return('results' => [property])
      allow(fake_api).to receive(:get).with('hackneyrepairs/v1/properties/00000503').and_return(property)
      allow(fake_api).to receive(:post)
        .with('hackneyrepairs/v1/repairs', anything)
        .and_return(
          'repairRequestReference' => '00367923',
          'priority' => 'N',
          'problem' => "My sink is blocked\n\nRoom: Kitchen\n\nLast question: \"Is your tap broken?\" -> Yes",
          'propertyReference' => '00000503',
          'workOrders' => [
            {
              'sorCode' => '0078965',
              'workOrderReference' => '09124578',
            },
          ]
        )
      allow(fake_api).to receive(:get)
        .with('hackneyrepairs/v1/repairs/00367923')
        .and_return(
          'repairRequestReference' => '00367923',
          'priority' => 'N',
          'problem' => "My sink is blocked\n\nRoom: Kitchen\n\nLast question: \"Is your tap broken?\" -> Yes",
          'propertyReference' => '00000503',
          'workOrders' => [
            {
              'sorCode' => '0078965',
              'workOrderReference' => '09124578',
            },
          ]
        )
      allow(fake_api).to receive(:get)
        .with('hackneyrepairs/v1/work_orders/09124578/available_appointments')
        .and_return(
          'results' => [
            { 'beginDate' => '2017-10-11T10:00:00Z', 'endDate' => '2017-10-11T12:00:00Z', 'bestSlot' => true },
            { 'beginDate' => '2017-10-11T12:00:00Z', 'endDate' => '2017-10-11T17:00:00Z', 'bestSlot' => true },
          ]
        )
      allow(fake_api).to receive(:post)
        .with(
          'hackneyrepairs/v1/work_orders/09124578/appointments',
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
              { 'text' => 'Yes', 'sor_code' => '0078965', 'desc' => 'kitchen_problem' },
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

      # Filter page:
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

      # Contact details:
      fill_in 'Full name', with: 'John Evans'
      fill_in 'Telephone number', with: '078 98765 432'
      click_on 'Continue'

      # Appointments:
      choose_radio_button 'Wednesday midday to 5pm (11th October)'
      click_on 'Continue'

      aggregate_failures do
        within '#confirmation' do
          expect(page).to have_content 'Your reference number is 09124578'
          expect(page).to have_content 'Wednesday 11th October'
          expect(page).to have_content 'between midday and 5pm'
        end

        within '#summary' do
          expect(page).to have_content t('confirmation.summary.name', name: 'John Evans')
          expect(page).to have_content t('confirmation.summary.phone', phone: '07898765432')
          expect(page).to have_content t('confirmation.summary.address', address: 'Ross Court 23, E5 8TE')
        end
      end

      expect(fake_api).to have_received(:post).with(
        'hackneyrepairs/v1/repairs',
        priority: 'N',
        problemDescription: "Room: Kitchen\n\nMy sink is blocked",
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
        'hackneyrepairs/v1/work_orders/09124578/appointments',
        beginDate: '2017-10-11T12:00:00Z',
        endDate: '2017-10-11T17:00:00Z',
      )
    end
  end

  scenario 'when the issue could not be completely diagnosed (and a callback is required)' do
    property = {
      'propertyReference' => '00000503',
      'address' => 'Ross Court 23',
      'postcode' => 'E5 8TE',
    }
    fake_api = instance_double(JsonApi)
    allow(fake_api).to receive(:get).with('hackneyrepairs/v1/properties?postcode=E5 8TE').and_return('results' => [property])
    allow(fake_api).to receive(:get).with('hackneyrepairs/v1/properties/00000503').and_return(property)
    allow(fake_api).to receive(:post)
      .with('hackneyrepairs/v1/repairs', anything)
      .and_return(
        'repairRequestReference' => '00367923',
        'priority' => 'N',
        'problem' => "My sink is blocked\n\nRoom: Other\n\nLast question: \"Which room?\" -> Other",
        'propertyReference' => '00000503',
      )
    allow(fake_api).to receive(:get)
      .with('hackneyrepairs/v1/repairs/00367923')
      .and_return(
        'repairRequestReference' => '00367923',
        'priority' => 'N',
        'problem' => "My sink is blocked\n\nRoom: Other\n\nLast question: \"Which room?\" -> Other",
        'propertyReference' => '00000503',
      )
    allow(JsonApi).to receive(:new).and_return(fake_api)

    fake_question_set = instance_double(QuestionSet)
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
            { 'text' => 'Other', 'desc' => 'describe_problem' },
          ],
        )
      )
    allow(QuestionSet).to receive(:new).and_return(fake_question_set)

    visit '/'
    click_on 'Start'

    # Emergency page:
    choose_radio_button 'No'
    click_on 'Continue'

    # Filter page:
    choose_radio_button 'No'
    click_on 'Continue'

    # Fake decision tree
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
    check 'morning (8am to midday)'
    check 'afternoon (midday to 5pm)'
    click_on 'Continue'

    aggregate_failures do
      within '#confirmation' do
        expect(page).to have_content 'Your reference number is 00367923'
        expect(page).to have_content 'between 8am and 5pm'
      end

      within '#summary' do
        expect(page).to have_content t('confirmation.summary.name', name: 'John Evans')
        expect(page).to have_content t('confirmation.summary.phone', phone: '07898765432')
        expect(page).to have_content t('confirmation.summary.address', address: 'Ross Court 23, E5 8TE')
      end
    end

    expect(fake_api).to have_received(:post).with(
      'hackneyrepairs/v1/repairs',
      priority: 'N',
      problemDescription: "Callback requested: between 8am and 5pm\n\nMy sink is blocked",
      propertyReference: '00000503',
      contact: {
        name: 'John Evans',
        telephoneNumber: '078 98765 432',
      },
    )
  end
end
