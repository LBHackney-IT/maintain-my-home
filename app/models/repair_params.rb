class RepairParams
  def initialize(answers)
    @answers = answers
  end

  def problem
    return 'n/a' if description.blank?
    return "#{description} (Room: #{room})" if room
    description
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

  def diagnosed?
    sor_code.present?
  end

  private

  def description
    @answers.fetch('describe_repair').fetch('description')
  end

  def room
    @answers.fetch('room', {})['room']
  end
end
