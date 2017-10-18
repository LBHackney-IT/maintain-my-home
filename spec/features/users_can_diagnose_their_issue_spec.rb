require 'rails_helper'

RSpec.feature 'Users can diagnose their issue' do
  scenario 'viewing a multiple-choice question' do
    fake_question_set = instance_double(QuestionSet)
    allow(fake_question_set)
      .to receive(:find)
      .with('first')
      .and_return(
        Question.new(
          'question' => 'Is there a danger of flooding?',
          'answers' => [
            { 'text' => 'Yeah' },
            { 'text' => 'Nope' },
          ],
        )
      )
    allow(QuestionSet).to receive(:new).and_return(fake_question_set)

    visit '/questions/first'

    expect(page).to have_content 'Is there a danger of flooding?'

    expect(page).to have_unchecked_field 'Yeah'
    expect(page).to have_unchecked_field 'Nope'
  end

  scenario 'viewing a question which requires text input' do
    fake_question_set = instance_double(QuestionSet)
    allow(fake_question_set)
      .to receive(:find)
      .with('first')
      .and_return(
        Question.new(
          'question' => 'Please describe your first pet',
        )
      )
    allow(QuestionSet).to receive(:new).and_return(fake_question_set)

    visit '/questions/first'

    expect(page).to have_content 'Please describe your first pet'
    expect(page).to have_field 'question_form_answer', type: 'textarea'
  end

  scenario 'choosing an answer that moves on to another question' do
    fake_question_set = instance_double(QuestionSet)
    allow(fake_question_set)
      .to receive(:find)
      .with('first')
      .and_return(
        Question.new(
          'question' => 'Are you having fun yet?',
          'answers' => [
            {
              'text' => 'Yes',
              'next' => 'second',
            },
            {
              'text' => 'No',
            },
          ],
        )
      )
    allow(fake_question_set)
      .to receive(:find)
      .with('second')
      .and_return(
        Question.new(
          'question' => 'Are you sure?',
          'answers' => [
            { 'text' => 'Absolutely!' },
          ],
        )
      )
    allow(QuestionSet).to receive(:new).and_return(fake_question_set)

    visit '/questions/first'
    choose_radio_button 'Yes'
    click_on 'Continue'

    expect(page.current_path).to eql '/questions/second'
    expect(page).to have_content 'Are you sure?'
    expect(page).to have_unchecked_field 'Absolutely!'
  end

  scenario 'choosing an answer that requires the user to see some static content' do
    fake_question_set = instance_double(QuestionSet)
    allow(fake_question_set)
      .to receive(:find)
      .with('flood')
      .and_return(
        Question.new(
          'question' => 'Is there a danger of flooding?',
          'answers' => [
            {
              'text' => 'Yes',
              'page' => 'emergency_contact',
            },
          ],
        )
      )
    allow(QuestionSet).to receive(:new).and_return(fake_question_set)

    visit '/questions/flood'
    choose_radio_button 'Yes'
    click_on 'Continue'

    expect(page.current_path).to eql '/pages/emergency_contact'
    expect(page).to have_content 'Please call our repair centre'
  end

  scenario 'choosing an answer redirects to the describe repair page by default' do
    fake_question_set = instance_double(QuestionSet)
    allow(fake_question_set)
      .to receive(:find)
      .with('where')
      .and_return(
        Question.new(
          'question' => 'Where does this question go?',
          'answers' => [
            { 'text' => 'Nowhere' },
          ],
        )
      )
    allow(QuestionSet).to receive(:new).and_return(fake_question_set)

    visit '/questions/where'
    choose_radio_button 'Nowhere'
    click_on 'Continue'

    expect(page).to have_content 'Is there anything else we should know?'
  end

  scenario 'not choosing an answer redisplays the form with an error' do
    fake_question_set = instance_double(QuestionSet)
    allow(fake_question_set)
      .to receive(:find)
      .with('preferences')
      .and_return(
        Question.new(
          'question' => 'Do you like errors?',
          'answers' => [
            { 'text' => 'No' },
          ],
        )
      )
    allow(QuestionSet).to receive(:new).and_return(fake_question_set)

    visit '/questions/preferences'
    click_on 'Continue'

    expect(page).to have_content 'Do you like errors?'
  end

  scenario 'clicking through the whole form, identifying an SOR code' do
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
    check 'morning (8am - 12pm)'
    click_on 'Continue'

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
end
