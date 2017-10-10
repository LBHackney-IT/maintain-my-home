class QuestionsController < ApplicationController
  def show
    questions = QuestionSet.new
    @question = questions.find(params[:id])
  end

  def submit
    questions = QuestionSet.new
    question = questions.find(params[:id])
    chosen_answer = form_params['answer']

    redirect_to question.redirect_path_for_answer(chosen_answer)
  end

  private

  def form_params
    params.require(:form).permit(:answer)
  end
end
