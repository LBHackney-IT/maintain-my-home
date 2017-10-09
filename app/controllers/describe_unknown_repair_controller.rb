class DescribeUnknownRepairController < ApplicationController
  def index
    @form = DescribeUnknownRepairForm.new
  end

  def submit
    @form = DescribeUnknownRepairForm.new(describe_unknown_repair_form_params)
    return render :index unless @form.valid?

    redirect_to address_search_path
  end

  private

  def describe_unknown_repair_form_params
    params.require(:describe_unknown_repair_form).permit!
  end
end
