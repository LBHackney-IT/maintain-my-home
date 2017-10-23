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
end
