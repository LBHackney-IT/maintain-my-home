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
      contact: create_contact_params(params),
    }.tap do |hash|
      hash[:workOrders] = create_work_order_params(params) if params.sor_code
    end
  end

  def create_work_order_params(params)
    [
      {
        sorCode: params.sor_code,
        estimatedunits: '1'
      },
    ]
  end

  def create_contact_params(params)
    {
      name: params.contact_full_name,
      telephoneNumber: params.contact_telephone_number,
    }
  end
end
