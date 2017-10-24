class AppointmentForm
  include ActiveModel::Model

  attr_reader :appointment_id

  validates :appointment_id, presence: true

  def initialize(hash = {})
    @appointment_id = hash[:appointment_id]
  end
end
