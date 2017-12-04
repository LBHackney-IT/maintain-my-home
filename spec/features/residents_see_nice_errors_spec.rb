require 'rails_helper'

RSpec.feature 'Error pages' do
  scenario 'when UH is not available' do
    fake_api = instance_double(JsonApi)
    connection_error = JsonApi::ConnectionError.new('Failed to open TCP connection to api_server:8000 (getaddrinfo: nodename nor servname provided, or not known)')
    allow(fake_api).to receive(:get)
      .with('v1/properties?postcode=E5 8TE')
      .and_raise connection_error
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

    allow(Rails.logger).to receive(:error)
    allow(Rollbar).to receive(:error)

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
    expect(Rails.logger).to have_received(:error)
      .with('[Handled] JsonApi::ConnectionError: Failed to open TCP connection to api_server:8000 (getaddrinfo: nodename nor servname provided, or not known)')
    expect(Rollbar).to have_received(:error)
      .with(connection_error)
  end
end

