class DescribeRepairController < ApplicationController
  def index
    @form = DescribeRepairForm.new
  end

  def submit
    @form = DescribeRepairForm.new(describe_repair_form_params)

    selected_answer_store.store_selected_answers(
      :describe_repair,
      description: @form.description
    )

    redirect_to address_search_path
  end

  private

  def describe_repair_form_params
    params.require(:describe_repair_form).permit!
  end
end
