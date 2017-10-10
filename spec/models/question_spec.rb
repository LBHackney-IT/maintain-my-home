require 'rails_helper'

RSpec.describe Question do
  describe '#initialize' do
    it 'is initialized with question data from a hash' do
      question = Question.new(
        'question' => 'Is it presented?',
        'answers' => [
          { 'text' => 'Yeah' },
          { 'text' => 'Nope' },
        ],
      )

      expect(question.title).to eql 'Is it presented?'
      expect(question.answers.size).to eql 2

      expect(question.answers[0]['text']).to eql 'Yeah'
      expect(question.answers[1]['text']).to eql 'Nope'
    end
  end
end
