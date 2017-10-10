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

  describe '#answers_for_collection' do
    it 'returns the answers in a format suitable for SimpleForm' do
      question = Question.new(
        'question' => 'Favourite animal?',
        'answers' => [
          { 'text' => 'Antelope' },
          { 'text' => 'Badger' },
        ],
      )

      expect(question.answers_for_collection).to include('Antelope', 'Badger')
    end
  end
end
