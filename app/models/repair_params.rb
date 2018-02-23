class RepairParams
  def initialize(answers)
    @answers = answers
  end

  def problem_description
    [
      metadata,
      description,
    ].compact.join("\n\n")
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

  def metadata
    data = []
    data << "Room: #{room}" if room_specified?
    data << "Problem with: #{problem}" if problem.present?
    data << "Callback requested: between #{callback_time}" if callback_time

    data.compact.join("\n").presence
  end

  def description
    @answers.fetch('describe_repair').fetch('description').tap do |desc|
      return 'No description given' if desc.blank?
    end
  end

  def room
    @answers.dig('room', 'room')
  end

  def last_question
    question = @answers.fetch('last_question')
    %("#{question.fetch('question')}" -> #{question.fetch('answer')})
  end

  def callback_time
    time = @answers.dig('callback_time', 'callback_time')
    return if time.blank?

    Callback::TimeSlot.new(time)
  end

  def room_specified?
    room.present? && room != 'Other'
  end

  def problem
    @answers.dig('problem', 'problem')
  end
end
