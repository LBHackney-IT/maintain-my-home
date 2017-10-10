require 'rails_helper'

RSpec.describe QuestionSet do
  describe '#initialize' do
    it 'loads and parses questions from a YAML file into a hash' do
      store = QuestionSet.new('spec/fixtures/basic_question.yml')

      expected = {
        'example' => {
          'question' => 'Is this an example?',
          'answers' => [
            { 'text' => 'Definitely' },
            { 'text' => 'Probably' },
          ],
        },
      }

      expect(store.questions).to eql expected
    end
  end

  describe '#find' do
    it 'returns the requested question' do
      store = QuestionSet.new('spec/fixtures/basic_question.yml')

      expected = {
        'question' => 'Is this an example?',
        'answers' => [
          { 'text' => 'Definitely' },
          { 'text' => 'Probably' },
        ],
      }

      expect(store.find('example')).to eql expected
    end

    it 'raises an error if the requestion question was not found' do
      store = QuestionSet.new('spec/fixtures/basic_question.yml')

      expect { store.find('wrong') }.to raise_error QuestionSet::UnknownQuestion
    end
  end
end
