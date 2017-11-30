require 'spec_helper'
require 'app/models/questions_validator'

RSpec.describe QuestionsValidator do
  describe '#validate!' do
    it 'throws an error if there is a link to a missing question' do
      questions = {
        'location' => {
          'question' => 'Where is the problem located?',
          'answers' => [
            {
              'text' => 'In a communal area',
              'next' => 'missing_question',
            },
          ],
        },
      }
      expect { QuestionsValidator.new(partial_checker: double, page_checker: double).validate!(questions) }
        .to raise_error(QuestionsValidator::MissingQuestions)
    end

    it 'throws an error if there is a link to a missing description partial' do
      questions = {
        'location' => {
          'question' => 'Where is the problem located?',
          'answers' => [
            {
              'text' => 'Somewhere else',
              'desc' => 'a_partial_which_does_not_exist',
            },
          ],
        },
      }
      partial_checker = instance_double('DescriptionPartialChecker', exists?: false)
      expect { QuestionsValidator.new(partial_checker: partial_checker, page_checker: double).validate!(questions) }
        .to raise_error(QuestionsValidator::MissingPartials)
    end

    it 'returns successfully if there is a link to a description partial which exists' do
      questions = {
        'location' => {
          'question' => 'Where is the problem located?',
          'answers' => [
            {
              'text' => 'Somewhere else',
              'desc' => 'a_partial_which_exists',
            },
          ],
        },
      }
      partial_checker = instance_double('DescriptionPartialChecker', exists?: true)
      expect { QuestionsValidator.new(partial_checker: partial_checker, page_checker: double).validate!(questions) }
        .to_not raise_error
    end

    it 'throws an error if there is a link to a page which does not exist' do
      questions = {
        'location' => {
          'question' => 'What is the problem?',
          'answers' => [
            {
              'text' => 'Something which requires a page',
              'page' => 'a_page_which_does_not_exist',
            },
          ],
        },
      }
      page_checker = instance_double('PageChecker', exists?: false)
      expect { QuestionsValidator.new(partial_checker: double, page_checker: page_checker).validate!(questions) }
        .to raise_error(QuestionsValidator::MissingPages)
    end

    it 'passes if there is a link to a page which exists' do
      questions = {
        'location' => {
          'question' => 'What is the problem?',
          'answers' => [
            {
              'text' => 'Something which requires a page',
              'page' => 'a_page_which_exists',
            },
          ],
        },
      }
      page_checker = instance_double('PageChecker', exists?: true)
      expect { QuestionsValidator.new(partial_checker: double, page_checker: page_checker).validate!(questions) }
        .to_not raise_error
    end
  end

  context 'when questions which must be included are specified' do
    it 'returns successfully if these questions are included' do
      questions = {
        'location' => {
          'question' => 'Where is the problem located?',
          'answers' => [
            {
              'text' => 'Somewhere else',
            },
          ],
        },
      }
      expect { QuestionsValidator.new(partial_checker: double, page_checker: double, mandatory_questions: ['location']).validate!(questions) }
        .to_not raise_error
    end

    it 'throws an error if these questions are not included' do
      questions = {}
      expect { QuestionsValidator.new(partial_checker: double, page_checker: double, mandatory_questions: ['which_room']).validate!(questions) }
        .to raise_error(QuestionsValidator::MissingMandatoryQuestions)
    end
  end
end
