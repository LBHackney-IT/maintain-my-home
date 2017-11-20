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
      partial_checker = instance_double('DescriptionPartialChecker', exists?: true)
      expect { QuestionsValidator.new(questions, partial_checker: partial_checker).validate! }
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
      expect { QuestionsValidator.new(questions, partial_checker: partial_checker).validate! }
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
      expect { QuestionsValidator.new(questions, partial_checker: partial_checker).validate! }
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
      partial_checker = instance_double('DescriptionPartialChecker', exists?: true)
      expect { QuestionsValidator.new(questions, partial_checker: partial_checker, mandatory_questions: ['location']).validate! }
        .to_not raise_error
    end

    it 'throws an error if these questions are not included' do
      questions = {}
      partial_checker = instance_double('DescriptionPartialChecker', exists?: true)
      expect { QuestionsValidator.new(questions, partial_checker: partial_checker, mandatory_questions: ['which_room']).validate! }
        .to raise_error(QuestionsValidator::MissingMandatoryQuestions)
    end
  end
end