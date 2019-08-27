require 'rails_helper'

RSpec.feature 'Residents see a useful message when no appointments available' do
  scenario 'when the API returns no available appointments' do
    property = {
      'propertyReference' => '00000503',
      'address' => 'Ross Court 23',
      'postcode' => 'E5 8TE',
    }
    fake_api = instance_double(JsonApi)
    allow(fake_api).to receive(:get).with('repairs/v1/properties?postcode=E5 8TE').and_return('results' => [property])
    allow(fake_api).to receive(:get).with('repairs/v1/properties/00000503').and_return(property)
    allow(fake_api).to receive(:post)
      .with('repairs/v1/repairs', anything)
      .and_return(
        'repairRequestReference' => '00367923',
        'priority' => 'N',
        'problem' => "Room: Kitchen\n\nMy sink is blocked",
        'propertyReference' => '00000503',
        'workOrders' => [
          {
            'sorCode' => '0078965',
            'workOrderReference' => '09124578',
          },
        ]
      )
    allow(fake_api).to receive(:get)
      .with('repairs/v1/repairs/00367923')
      .and_return(
        'repairRequestReference' => '00367923',
        'priority' => 'N',
        'problem' => "Room: Kitchen\n\nMy sink is blocked",
        'propertyReference' => '00000503',
        'workOrders' => [
          {
            'sorCode' => '0078965',
            'workOrderReference' => '09124578',
          },
        ]
      )
    allow(fake_api).to receive(:get)
      .with('repairs/v1/work_orders/09124578/available_appointments')
      .and_return(
        'results' => []
      )
    allow(JsonApi).to receive(:new).and_return(fake_api)

    stub_google_sheets_logger

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

    aggregate_failures do
      expect(page).to have_content 'Please call us on 020 8356 3691 to arrange an appointment'
      expect(page).to have_content 'Your reference number is 09124578'
    end

    expect(fake_api).to have_received(:post).with(
      'repairs/v1/repairs',
      priority: 'N',
      problemDescription: "Room: Kitchen\n\nMy sink is blocked",
      propertyReference: '00000503',
      contact: {
        name: 'John Evans',
        telephoneNumber: '078 98765 432',
      },
      workOrders: [
        {
          sorCode: '0078965',
          estimatedunits: '1'
        },
      ]
    )
  end
end
