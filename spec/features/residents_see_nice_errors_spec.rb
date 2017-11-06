require 'rails_helper'

RSpec.feature 'Error pages' do
  scenario 'when UH is not available' do
    fake_api = instance_double(JsonApi)
    allow(fake_api).to receive(:get)
      .with('v1/properties?postcode=E5 8TE')
      .and_raise JsonApi::ConnectionError
    allow(JsonApi).to receive(:new).and_return(fake_api)

    fake_question_set = instance_double(QuestionSet)
    allow(fake_question_set)
      .to receive(:find)
      .with('location')
      .and_return(
        Question.new(
          'question' => 'Where is the problem?',
          'answers' => [
            { 'text' => 'Kitchen' },
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
    choose_radio_button 'Kitchen'
    click_on 'Continue'

    # Describe problem:
    fill_in 'describe_repair_form_description', with: 'My sink is blocked'
    click_on 'Continue'

    # Address search:
    fill_in 'Postcode', with: 'E5 8TE'
    click_on 'Find my address'

    expect(page).to have_content "We're really sorry"
  end
end

