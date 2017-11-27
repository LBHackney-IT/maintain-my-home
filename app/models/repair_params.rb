class RepairParams
  def initialize(answers)
    @answers = answers
  end

  def problem_description
    lines = [description]
    lines << "Room: #{room}" if room.present?
    lines << "Callback requested: between #{callback_time}" if callback_time
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

  def contact_full_name
    @answers.fetch('contact_details').fetch('full_name')
  end

  def contact_telephone_number
    @answers.fetch('contact_details').fetch('telephone_number')
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

  def callback_time
    time = @answers.dig('callback_time', 'callback_time')
    return if time.blank?

    Callback::TimeSlot.new(time)
  end
end
