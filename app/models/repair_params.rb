class RepairParams
  def initialize(answers)
    @answers = answers
  end

  def problem
    if description.present? && room.present?
      "#{description} (Room: #{room})"
    elsif description.present?
      description
    elsif room.present?
      "Room: #{room}"
    else
      'n/a'
    end
  end

  def property_reference
    @answers.fetch('address').fetch('propertyReference')
  end

  def priority
    'N'
  end

  def sor_code
    @answers.dig('diagnosis', 'sor_code')
  end

  def diagnosed?
    sor_code.present?
  end

  private

  def description
    @answers.fetch('describe_repair').fetch('description')
  end

  def room
    @answers.dig('room', 'room')
  end
end
