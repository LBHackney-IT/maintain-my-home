class ContactDetailsWithCallbackForm
  include ActiveModel::Model

  attr_reader :full_name, :telephone_number, :callback_time

  validates :full_name, :telephone_number, :callback_time, presence: true

  def initialize(hash = {})
    @full_name = hash[:full_name]
    @telephone_number = hash[:telephone_number]
    @callback_time = hash[:callback_time]
  end
end
