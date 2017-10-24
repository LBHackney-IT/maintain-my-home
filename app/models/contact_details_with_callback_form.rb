class ContactDetailsWithCallbackForm < ContactDetailsForm
  attr_reader :callback_time

  validates :callback_time, presence: true

  def initialize(hash = {})
    super(hash)
    @callback_time = hash[:callback_time]
  end
end
