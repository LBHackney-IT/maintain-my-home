class AppointmentForm
  include ActiveModel::Model

  attr_reader :appointment_id

  validates :appointment_id, presence: true

  def initialize(hash = {}, verifier: ActiveSupport::MessageVerifier)
    @appointment_id = hash['appointment_id']
    @verifier = verifier
  end

  def begin_date
    decrypted_appointment.fetch('beginDate')
  end

  def end_date
    decrypted_appointment.fetch('endDate')
  end

  private

  def decrypted_appointment
    @decrypted_appointment ||= @verifier
                               .new(ENV.fetch('ENCRYPTION_SECRET'))
                               .verify(@appointment_id)
  end
end
