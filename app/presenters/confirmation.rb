class Confirmation
  class InvalidCallbackTimeError < StandardError; end

  def initialize(request_reference:, answers:, api: HackneyApi.new)
    @request_reference = request_reference
    @answers = answers
    @api = api
  end

  def request_reference
    repair = Repair.new(
      @api.get_repair(repair_request_reference: @request_reference)
    )

    repair.work_order_reference || repair.request_reference
  end

  def address
    address_answer = @answers.fetch('address')
    [
      address_answer.fetch('short_address'),
      address_answer.fetch('postcode'),
    ].join(', ')
  end

  def full_name
    contact_details_answer.fetch('full_name')
  end

  def telephone_number
    number = contact_details_answer.fetch('telephone_number')
    format_telephone_number(number)
  end

  def scheduled_action
    callback = @answers['callback_time']
    if callback
      time_slot = callback.fetch('callback_time')
      Callback.new(time_slot: time_slot, request_reference: @request_reference)
    else
      Appointment.new
    end
  end

  def room
    @answers.fetch('room').fetch('room')
  end

  def description
    @answers.fetch('describe_repair').fetch('description')
  end

  private

  def contact_details_answer
    @answers.fetch('contact_details')
  end

  def format_telephone_number(number)
    number.delete("\s")
  end
end
