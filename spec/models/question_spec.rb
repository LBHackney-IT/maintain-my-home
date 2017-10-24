require 'rails_helper'

RSpec.describe Question do
  describe '#title' do
    it 'is based on question data from a hash' do
      question = Question.new(
        'question' => 'Is it presented?',
        'answers' => [
          { 'text' => 'Yeah' },
          { 'text' => 'Nope' },
        ],
      )

      expect(question.title).to eql 'Is it presented?'
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

  describe '#answer_data' do
    it 'returns data for the given answer' do
      question = Question.new(
        'question' => 'Favourite animal?',
        'answers' => [
          { 'text' => 'Antelope', 'next' => 'cooking_style' },
          { 'text' => 'Badger', 'sor_code' => '012345' },
        ],
      )

      antelope = question.answer_data('Antelope')
      expect(antelope['text']).to eql 'Antelope'
      expect(antelope['next']).to eql 'cooking_style'

      badger = question.answer_data('Badger')
      expect(badger['text']).to eql 'Badger'
      expect(badger['sor_code']).to eql '012345'
    end

    context 'when the answer is not valid' do
      it 'raises an error' do
        question = Question.new(
          'question' => 'Favourite animal?',
          'answers' => [
            { 'text' => 'Antelope', 'next' => 'cooking_style' },
          ],
        )

        expect { question.answer_data('skink') }.to raise_error(Question::InvalidAnswerError)
      end
    end
  end

  describe '#redirect_path_for_answer' do
    it 'returns the path to the next question, if answer has "next" key' do
      question = Question.new(
        'question' => 'Where do you want to go?',
        'answers' => [
          {
            'text' => 'London',
            'next' => 'next',
          },
        ],
      )

      expect(question.redirect_path_for_answer('London')).to eql '/questions/next'
    end

    it 'returns the path to a static page, if answer has "page" key' do
      question = Question.new(
        'question' => 'Where do you want to go?',
        'answers' => [
          {
            'text' => 'London',
            'page' => 'info',
          },
        ],
      )

      expect(question.redirect_path_for_answer('London')).to eql '/pages/info'
    end
  end

  describe '#redirect_path' do
    it 'redirects to the address search' do
      question = Question.new(
        'question' => 'Please describe your problem',
      )

      expect(question.redirect_path).to eql '/address-search'
    end

    context 'when question has "next" key' do
      it 'returns the path to the next question' do
        question = Question.new(
          'question' => 'Please describe your problem',
          'next' => 'another'
        )

        expect(question.redirect_path).to eql '/questions/another'
      end
    end
  end

  describe '#multiple_choice?' do
    it 'is true when the question has possible answers' do
      question = Question.new(
        'question' => 'Cat or dog?',
        'answers' => [
          { 'text': 'Cat' },
          { 'text': 'Dog' },
        ],
      )

      expect(question.multiple_choice?).to be_truthy
    end

    it 'is false when the question has no answers' do
      question = Question.new(
        'question' => 'Please describe your cat?'
      )

      expect(question.multiple_choice?).to be_falsey
    end
  end
end
