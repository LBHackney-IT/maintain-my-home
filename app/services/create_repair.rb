class CreateRepair
  def initialize(api: HackneyApi.new)
    @api = api
  end

  def call(answers:)
    params = RepairParams.new(answers)
    result = @api.create_repair(create_repair_params(params))
    Result.new(result)
  end

  private

  def create_repair_params(params)
    {
      priority: params.priority,
      problem: params.problem,
      propertyRef: params.property_reference,
    }.tap do |hash|
      hash[:repairOrders] = create_work_order_params(params) if params.sor_code
    end
  end

  def create_work_order_params(params)
    [
      {
        jobCode: params.sor_code,
        propertyReference: params.property_reference,
      },
    ]
  end

  class RepairParams
    def initialize(answers)
      @answers = answers
    end

    def problem
      problem = @answers.fetch('describe_repair').fetch('description')

      return 'n/a' if problem.blank?
      problem
    end

    def property_reference
      @answers.fetch('address').fetch('property_reference')
    end

    def priority
      'N'
    end

    def sor_code
      @answers.fetch('diagnosis', {})['sor_code']
    end
  end

  class Result
    def initialize(result)
      @result = result
    end

    def request_reference
      @result.fetch('requestReference')
    end
  end
end
