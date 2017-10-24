class RepairParams
  def initialize(answers)
    @answers = answers
  end

  def problem
    @answers.fetch('describe_repair').fetch('description').tap do |problem|
      return 'n/a' if problem.blank?
    end
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
