require 'rails_helper'

RSpec.feature 'Users can diagnose their issue' do
  scenario 'viewing the first question' do
    allow_any_instance_of(QuestionSet)
      .to receive(:questions)
      .and_return(
        'first' => {
          'question' => 'Is there a danger of flooding?',
          'answers' => [
            { 'text' => 'Yeah' },
            { 'text' => 'Nope' },
          ],
        }
      )
    visit '/questions/first'

    expect(page).to have_content 'Is there a danger of flooding?'

    expect(page).to have_unchecked_field 'Yeah'
    expect(page).to have_unchecked_field 'Nope'
  end
end
