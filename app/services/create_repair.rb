class CreateRepair
  def initialize(api: HackneyApi.new)
    @api = api
  end

  def call(answers:)
    @api.create_repair(create_repair_params(answers))
  end

  private

  def create_repair_params(answers)
    params = Params.new(answers)
    {
      priority: params.priority,
      problem: params.problem,
      propertyRef: params.property_reference,
    }
  end

  class Params
    def initialize(answers)
      @answers = answers
    end

    def problem
      @answers.fetch('describe_repair').fetch('description')
    end

    def property_reference
      @answers.fetch('address').fetch('property_reference')
    end

    def priority
      'N'
    end
  end
end
