class DescribeRepair
  attr_reader :form

  def initialize(form_params: {}, details:, answers:)
    @form_params = form_params
    @answers = answers
    @details = details
  end

  def partial
    if diagnosed?
      'anything_else'
    else
      @details || 'describe_problem'
    end
  end

  def form
    @form ||= build_form(@form_params)
  end

  private

  def diagnosed?
    !RepairParams.new(@answers).sor_code.nil?
  end

  def build_form(form_params)
    if diagnosed?
      DescribeRepairForm.new(form_params)
    else
      DescribeUnknownRepairForm.new(form_params)
    end
  end
end
