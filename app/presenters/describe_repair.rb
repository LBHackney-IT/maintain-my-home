class DescribeRepair
  attr_reader :form

  def initialize(form_params: {}, details:, answers:, partial_checker:)
    @form_params = form_params
    @answers = answers
    @details = details
    @partial_checker = partial_checker
  end

  def partial
    if diagnosed?
      'anything_else'
    elsif @partial_checker.exists?(@details)
      @details
    else
      'describe_problem'
    end
  end

  def form
    @form ||= build_form(@form_params)
  end

  private

  def diagnosed?
    RepairParams.new(@answers).diagnosed?
  end

  def build_form(form_params)
    if diagnosed?
      DescribeRepairForm.new(form_params)
    else
      DescribeUnknownRepairForm.new(form_params)
    end
  end
end
