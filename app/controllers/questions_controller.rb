class QuestionsController < ApplicationController
  def show
    @form = QuestionForm.new
    @question = questions.find(params[:id])
  end

  def submit
    @form = QuestionForm.new(question_form_params)
    @question = questions.find(params[:id])

    question_saver =
      QuestionSaver.new(
        question: @question,
        selected_answer_store: selected_answer_store,
      )

    if question_saver.save(@form)
      redirect_to @question.redirect_path_for_answer(@form.answer)
    else
      render :show
    end
  end

  private

  def question_form_params
    params.require(:question_form).permit(:answer)
  end

  def questions
    QuestionSet.new(
      partial_checker: description_partial_checker,
      page_checker: StaticPageChecker.new(lookup_context: lookup_context)
    )
  end
end
