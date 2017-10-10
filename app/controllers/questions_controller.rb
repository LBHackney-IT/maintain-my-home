class QuestionsController < ApplicationController
  def show
    questions = QuestionSet.new
    @question = questions.find(params[:id])
  end
end
