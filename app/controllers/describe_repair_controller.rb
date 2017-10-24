class DescribeRepairController < ApplicationController
  def index
    @describe_repair = DescribeRepair.new(
      details: params[:details],
      answers: selected_answer_store.selected_answers
    )
  end

  def submit
    @describe_repair = DescribeRepair.new(
      form_params: describe_repair_form_params,
      details: params[:details],
      answers: selected_answer_store.selected_answers
    )

    if @describe_repair.form.valid?
      selected_answer_store.store_selected_answers(
        :describe_repair,
        description: @describe_repair.form.description
      )

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
