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

  class Result
    def initialize(result)
      @result = result
    end

    def request_reference
      @result.fetch('requestReference') do |_key|
        @result.fetch('repairRequestReference')
      end
    end

    def work_order_reference
      @result.fetch('orderReference')
    end
  end
end
