class Callback
  attr_reader :request_reference

  def initialize(time_slot:, request_reference:)
    @time_slot = TimeSlot.new(time_slot)
    @request_reference = request_reference
  end

  def time
    @time_slot.to_s
  end

  def to_partial_path
    '/confirmations/callback'
  end

  class TimeSlot
    class InvalidCallbackTimeError < StandardError; end

    def initialize(time_slot)
      @time_slot = time_slot
    end

    def to_s
      case @time_slot
      when ['morning']
        '8am and midday'
      when ['afternoon']
        'midday and 5pm'
      when %w[morning afternoon]
        '8am and 5pm'
      else
        raise InvalidCallbackTimeError
      end
    end
  end
end
