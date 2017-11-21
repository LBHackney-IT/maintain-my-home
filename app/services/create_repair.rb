class CreateRepair
  def initialize(api: HackneyApi.new)
    @api = api
  end

  def call(answers:)
    params = RepairParams.new(answers)
    result = @api.create_repair(create_repair_params(params))
    Repair.new(result)
  end

  private

  def create_repair_params(params)
    {
      priority: params.priority,
      problemDescription: params.problem_description,
      propertyReference: params.property_reference,
    }.tap do |hash|
      hash[:repairOrders] = create_work_order_params(params) if params.sor_code
    end
  end

  def create_work_order_params(params)
    [
      {
        jobCode: params.sor_code,
      },
    ]
  end
end
