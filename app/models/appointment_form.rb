class AppointmentForm
  class InvalidAppointment < StandardError; end

  include ActiveModel::Model

  attr_reader :appointment_id

  validates :appointment_id, presence: true

  def initialize(hash = {})
    @appointment_id = hash[:appointment_id]

    validate_appointment_dates!
  end

  def begin_date
    split_date.first
  end

  def end_date
    split_date.last
  end

  private

  def split_date
    @split_date ||= @appointment_id.to_s.split('|')
  end

  def validate_appointment_dates!
    return unless @appointment_id

    raise InvalidAppointment unless split_date.size == 2

    split_date.each do |date|
      begin
        Time.zone.parse(date)
      rescue ArgumentError
        raise InvalidAppointment
      end
    end
  end
end
