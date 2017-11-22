class RepairParams
  def initialize(answers)
    @answers = answers
  end

  def problem
    lines = [description]
    lines << "Room: #{room}" if room.present?
    lines.compact.join("\n\n")
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
    @answers.fetch('describe_repair').fetch('description').tap do |desc|
      return 'No description given' if desc.blank?
    end
  end

  def room
    @answers.dig('room', 'room')
  end
end
