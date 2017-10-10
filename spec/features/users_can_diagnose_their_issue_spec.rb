require 'rails_helper'

RSpec.feature 'Users can diagnose their issue' do
  scenario 'viewing the first question' do
    allow_any_instance_of(QuestionSet)
      .to receive(:questions)
      .and_return(
        'first' => {
          'question' => 'Is there a danger of flooding?',
        }
      )
    visit '/questions/first'

    expect(page).to have_content 'Is there a danger of flooding?'
  end
end
