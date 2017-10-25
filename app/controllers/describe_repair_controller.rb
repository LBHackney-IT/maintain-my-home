class DescribeRepairController < ApplicationController
  def index
    @describe_repair = DescribeRepair.new(
      details: params[:details],
      answers: selected_answer_store.selected_answers,
      partial_checker: description_partial_checker
    )
  end

  def submit
    @describe_repair = DescribeRepair.new(
      form_params: describe_repair_form_params,
      details: params[:details],
      answers: selected_answer_store.selected_answers,
      partial_checker: description_partial_checker
    )

    saver =
      DescribeRepairSaver.new(selected_answer_store: selected_answer_store)

    if saver.save(@describe_repair.form)
      redirect_to address_search_path
    else
      render 'describe_repair/index'
    end
  end

  private

  def describe_repair_form_params
    params.require(:describe_repair_form).permit!
  end
end
