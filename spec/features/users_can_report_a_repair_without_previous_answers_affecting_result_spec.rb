require 'rails_helper'

RSpec.feature 'Users can report a repair without previous answers affecting the result' do
  scenario 'when the user chose a callback time last time and now has to book an appointment' do
    property = {
      'propertyReference' => '00000512',
      'address' => 'Ross Court 42',
      'postcode' => 'E5 8TE',
    }
    fake_api = instance_double(JsonApi)
    allow(fake_api).to receive(:get)
      .with('hackneyrepairs/v1/properties?postcode=E5 8TE')
      .and_return('results' => [property])
    allow(fake_api).to receive(:get)
      .with('hackneyrepairs/v1/properties/00000512')
      .and_return(property)
    allow(fake_api).to receive(:post)
      .with('hackneyrepairs/v1/repairs', anything)
      .and_return(
        'repairRequestReference' => '00367923',
        'priority' => 'N',
        'problemDescription' => 'My sink is blocked',
        'propertyReference' => '00000503',
        'workOrders' => [
          {
            'sorCode' => '0078965',
            'workOrderReference' => '09124578',
          },
        ],
      )
    allow(fake_api).to receive(:get)
      .with('hackneyrepairs/v1/repairs/00367923')
      .and_return(
        'repairRequestReference' => '00367923',
        'orderReference' => '09124578',
        'priority' => 'N',
        'problemDescription' => 'My sink is blocked',
        'propertyReference' => '00000503',
        'workOrders' => [
          {
            'sorCode' => '0078965',
            'workOrderReference' => '09124578',
          },
        ],
      )
    allow(fake_api).to receive(:get)
      .with('hackneyrepairs/v1/work_orders/09124578/available_appointments')
      .and_return(
        'results' => [
          {
            'beginDate' => '2017-11-27T10:00:00Z',
            'endDate' => '2017-11-27T12:00:00Z',
            'bestSlot' => true,
          },
        ]
      )
    allow(fake_api).to receive(:post)
      .with('hackneyrepairs/v1/work_orders/09124578/appointments', anything)
      .and_return(
        'beginDate' => '2017-11-27T10:00:00Z',
        'endDate' => '2017-11-27T12:00:00Z'
      )
    allow(JsonApi).to receive(:new).and_return(fake_api)

    fake_question_set = instance_double(QuestionSet)
    allow(fake_question_set)
      .to receive(:find)
      .with('which_room')
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

    # FIRST VISIT ========================
    visit '/'
    click_on 'Start'

    # Emergency page:
    choose_radio_button 'No'
    click_on 'Continue'

    # Fake decision tree
    choose_radio_button 'Kitchen'
    click_on 'Continue'

    choose_radio_button 'Yes' # Gets a SOR code
    click_on 'Continue'

    # SECOND VISIT ========================
    visit '/'
    click_on 'Start'

    # Emergency page:
    choose_radio_button 'No'
    click_on 'Continue'

    # Fake decision tree
    choose_radio_button 'Kitchen'
    click_on 'Continue'

    choose_radio_button 'No' # Doesn't get a SOR code
    click_on 'Continue'

    # Describe problem:
    fill_in 'describe_repair_form_description', with: 'My sink is blocked'
    click_on 'Continue'

    # Address search:
    fill_in 'Postcode', with: 'E5 8TE'
    click_on 'Find my address'

    # Address selection:
    choose_radio_button 'Ross Court 42'
    click_on 'Continue'

    # Contact details
    fill_in 'Full name', with: 'Jane Evans'
    fill_in 'Telephone number', with: '07900 424242'
    choose_radio_button 'morning (8am to midday)'
    click_on 'Continue'

    expect(page).to have_content 'We will call you between 8am and midday'
  end
end
