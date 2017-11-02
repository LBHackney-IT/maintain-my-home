class QuestionsValidator
  class Error < StandardError; end
  class MissingQuestions < Error; end
  class MissingMandatoryQuestions < Error; end
  class MissingPartials < Error; end

  def initialize(questions, partial_checker:, mandatory_questions: [])
    @questions = questions
    @partial_checker = partial_checker
    @mandatory_questions = mandatory_questions
  end

  def validate!
    validate_next
    validate_desc
    validate_mandatory
  end

  private

  def validate_next
    missing_question_ids = answer_values_for('next') - question_ids

    raise MissingQuestions, missing_question_ids if missing_question_ids.any?
  end

  def validate_desc
    missing_partials = answer_values_for('desc').reject do |partial_name|
      @partial_checker.exists?(partial_name)
    end

    raise MissingPartials, missing_partials if missing_partials.any?
  end

  def validate_mandatory
    missing_question_ids = @mandatory_questions - question_ids

    return if missing_question_ids.empty?
    raise MissingMandatoryQuestions, missing_question_ids
  end

  def question_ids
    @questions.keys.uniq
  end

  def answer_values_for(answer_type)
    @questions.reduce([]) do |ids, (_k, v)|
      answers = Array(v['answers'])
      ids + answers.map { |a| a[answer_type] }.compact
    end
  end
end
