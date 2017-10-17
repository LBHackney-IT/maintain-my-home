require 'rails_helper'

RSpec.describe QuestionSet do
  describe '#initialize' do
    it 'throws an error if the YAML file is not in the correct format' do
      expect do
        QuestionSet.new('spec/fixtures/broken.yml')
      end.to raise_error(QuestionSet::BadlyFormattedYaml)
    end

    it 'throws an error if the YAML file links to a missing question' do
      expect do
        QuestionSet.new('spec/fixtures/missing_questions.yml')
      end.to raise_error(QuestionSet::MissingQuestions)
    end
  end

  describe '#find' do
    it 'returns the requested question' do
      store = QuestionSet.new('spec/fixtures/basic_question.yml')
      question = store.find('example')

      expect(question).to be_a(Question)
      expect(question.title).to eql 'Is this an example?'
    end

    it 'raises an error if the requested question was not found' do
      store = QuestionSet.new('spec/fixtures/basic_question.yml')

      expect { store.find('wrong') }.to raise_error QuestionSet::UnknownQuestion
    end
  end
end
