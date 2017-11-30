class QuestionsValidator
  class Error < StandardError; end
  class MissingQuestions < Error; end
  class MissingMandatoryQuestions < Error; end
  class MissingPartials < Error; end

  def initialize(partial_checker:, mandatory_questions: [])
    @partial_checker = partial_checker
    @mandatory_questions = mandatory_questions
  end

  def validate!(questions)
    questions = Questions.new(questions)
    validate_next!(questions)
    validate_desc!(questions)
    validate_mandatory!(questions)
  end

  private

  def validate_next!(questions)
    missing_question_ids = questions.answer_values_for('next') - questions.ids

    raise MissingQuestions, missing_question_ids if missing_question_ids.any?
  end

  def validate_desc!(questions)
    missing_partials = questions.answer_values_for('desc').reject do |partial|
      @partial_checker.exists?(partial)
    end

    raise MissingPartials, missing_partials if missing_partials.any?
  end

  def validate_mandatory!(questions)
    missing_question_ids = @mandatory_questions - questions.ids

    return if missing_question_ids.empty?
    raise MissingMandatoryQuestions, missing_question_ids
  end

  class Questions
    def initialize(questions)
      @questions = questions
    end

    def ids
      @questions.keys.uniq
    end

    def answer_values_for(answer_type)
      @questions.reduce([]) do |ids, (_k, v)|
        answers = Array(v['answers'])
        ids + answers.map { |a| a[answer_type] }.compact
      end
    end
  end
end
