require 'rails_helper'
RSpec.feature 'RCC operative can see spreadsheet log of repairs' do
  around(:each) do |example|
    travel_to Time.zone.local(2017, 10, 1) do
      example.run
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

    fake_google_sheets_logger = stub_google_sheets_logger

    stub_diagnosis_question(question: 'Which room?', answers: [
                              { 'text' => 'Kitchen', 'next' => 'kitchen' },
                              { 'text' => 'Bathroom', 'desc' => 'describe_problem' },
                              { 'text' => 'Other', 'desc' => 'describe_problem' },
                            ])

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

    expect(fake_google_sheets_logger).to have_received(:call).with(
      instance_of(Repair),
      'callback'
    )
  end
end
