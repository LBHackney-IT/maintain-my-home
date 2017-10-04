class Confirmation
  attr_reader :repair_request_id

  def initialize(repair_request_id:, answers:)
    @repair_request_id = repair_request_id
    @answers = answers
  end

  def address
    address_answer = @answers.fetch('address')
    [
      address_answer.fetch('short_address'),
      address_answer.fetch('postcode'),
    ].join(', ')
  end
end
