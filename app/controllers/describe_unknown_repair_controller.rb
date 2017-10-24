class DescribeUnknownRepairController < ApplicationController
  def index
    @form = DescribeUnknownRepairForm.new
    partial = params[:details] || 'describe_problem'
    @partial = "describe_repair/#{partial}"

    render 'describe_repair/index'
  end

  def submit
    @form = DescribeUnknownRepairForm.new(describe_repair_form_params)
    partial = params[:details] || 'describe_problem'
    @partial = "describe_repair/#{partial}"

    return render 'describe_repair/index' unless @form.valid?

    redirect_to address_search_path
  end

  private

  def describe_repair_form_params
    params.require(:describe_repair_form).permit!
  end
end
