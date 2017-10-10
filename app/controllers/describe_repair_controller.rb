class DescribeRepairController < ApplicationController
  def index
    @form = DescriptionForm.new
    @back = Back.new(controller_name: 'questions/start')
  end

  def submit
    @form = DescriptionForm.new(description_form_params)

    SelectedAnswerStore.new(session).store_selected_answers(
      :describe_repair,
      description: @form.description
    )

    redirect_to address_search_path
  end

  private

  def description_form_params
    params.require(:description_form).permit!
  end
end
