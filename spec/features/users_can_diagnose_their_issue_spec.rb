require 'rails_helper'

RSpec.feature 'Users can diagnose their issue' do
  scenario 'viewing a multiple-choice question' do
    stub_diagnosis_question(
      question: 'Is there a danger of flooding?',
      id: 'first',
      answers: [
        { 'text' => 'Yeah' },
        { 'text' => 'Nope' },
      ],
    )

    visit '/questions/first'

    expect(page).to have_content 'Is there a danger of flooding?'

    expect(page).to have_unchecked_field 'Yeah'
    expect(page).to have_unchecked_field 'Nope'
  end

  scenario 'choosing an answer that moves on to another question' do
    fake_question_set = instance_double(QuestionSet)
    allow(fake_question_set)
      .to receive(:find)
      .with('first')
      .and_return(
        Question.new(
          'id' => 'first',
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
          'id' => 'second',
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
    stub_diagnosis_question(
      question: 'Is there a danger of flooding?',
      id: 'flood',
      answers: [
        {
          'text' => 'Yes',
          'page' => 'emergency_contact',
        },
      ],
    )

    visit '/questions/flood'
    choose_radio_button 'Yes'
    click_on 'Continue'

    expect(page.current_path).to eql '/pages/emergency_contact'
    expect(page).to have_content 'Emergency repairs'
  end

  scenario 'when the repair was diagnosed' do
    stub_diagnosis_question(
      question: 'Where does this question go?',
      id: 'where',
      answers: [{ 'text' => 'To a required describe form', 'sor_code' => '022456' }]
    )

    visit '/questions/where'
    choose_radio_button 'To a required describe form'
    click_on 'Continue'

    expect(page).to have_content 'Let us know any further details'

    click_on 'Continue'

    expect(page).to have_content "can't be blank"
  end

  scenario 'when the repair was not diagnosed' do
    stub_diagnosis_question(
      question: 'Where does this question go?',
      id: 'where',
      answers: [{ 'text' => 'To a required describe form' }]
    )

    visit '/questions/where'
    choose_radio_button 'To a required describe form'
    click_on 'Continue'

    expect(page).to have_content 'Let us know any further details you think might help us'

    click_on 'Continue'

    expect(page).to have_content "can't be blank"
  end

  scenario 'choosing an answer with a special describe repair page' do
    stub_diagnosis_question(
      question: 'Where does this question go?',
      id: 'where',
      answers: [{ 'text' => 'Somewhere special', 'desc' => 'damp' }]
    )

    visit '/questions/where'
    choose_radio_button 'Somewhere special'
    click_on 'Continue'

    expect(page).to have_content 'The exact location of the damp'

    # Submit invalid details - the same text should display
    click_on 'Continue'

    expect(page).to have_content 'The exact location of the damp'
  end

  scenario 'not choosing an answer redisplays the form with an error' do
    stub_diagnosis_question(
      question: 'Do you like errors?',
      id: 'preferences',
      answers: [{ 'text' => 'No' }]
    )

    visit '/questions/preferences'
    click_on 'Continue'

    expect(page).to have_content 'Do you like errors?'
  end
end
