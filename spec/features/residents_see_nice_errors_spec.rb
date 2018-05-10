require 'rails_helper'

RSpec.feature 'Error pages' do
  scenario 'when an application error occurs' do
    runtime_error = RuntimeError.new("They're coming outta the walls! They're coming outta the goddamn walls!")
    allow(StartForm).to receive(:new)
      .and_raise runtime_error

    allow(Rails.logger).to receive(:error)
    allow(Rollbar).to receive(:error)

    visit '/'
    expect { click_on 'Start' }.to raise_error runtime_error # ...and rely on rails default routing to render the error
  end

  scenario 'when the user was redirected to an internal server error page' do
    visit '/500'
    expect(page).to have_content "We're really sorry"
    click_on 'contact us'
    expect(page).to have_content 'Please phone us'
  end

  scenario 'when a page was not found' do
    visit '/404'
    expect(page).to have_content "Sorry - the page you were looking for doesn't seem to exist!"
    click_on 'contact us'
    expect(page).to have_content 'Please phone us'
  end

  scenario 'when a page was not found' do
    visit '/422'
    expect(page).to have_content 'Something seems to have gone wrong while reporting your repair'
    click_on 'contact us'
    expect(page).to have_content 'Please phone us'
  end

  scenario 'when UH is not available' do
    fake_api = instance_double(JsonApi)
    connection_error = JsonApi::ConnectionError.new('Failed to open TCP connection to api_server:8000 (getaddrinfo: nodename nor servname provided, or not known)')
    allow(fake_api).to receive(:get)
      .with('hackneyrepairs/properties?postcode=E5 8TE')
      .and_raise connection_error
    allow(JsonApi).to receive(:new).and_return(fake_api)

    fake_question_set = instance_double(QuestionSet)
    allow(fake_question_set)
      .to receive(:find)
      .with('which_room')
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

