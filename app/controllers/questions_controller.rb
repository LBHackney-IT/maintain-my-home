class QuestionsController < ApplicationController
  def show
    @form = QuestionForm.new
    @question = QuestionSet.new.find(params[:id])
  end

  def submit
    @form = QuestionForm.new(question_form_params)
    @question = QuestionSet.new.find(params[:id])

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
end
