class Callback
  class InvalidCallbackTimeError < StandardError; end

  attr_reader :request_reference

  def initialize(time_slot:, request_reference:)
    @time_slot = time_slot
    @request_reference = request_reference
  end

  def time
    case @time_slot
    when ['morning']
      '8am and 12pm'
    when ['afternoon']
      '12pm and 5pm'
    when %w[morning afternoon]
      '8am and 5pm'
    else
      raise InvalidCallbackTimeError
    end
  end

  def to_partial_path
    '/confirmations/callback'
  end
end
