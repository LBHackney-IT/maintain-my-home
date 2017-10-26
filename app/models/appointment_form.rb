class AppointmentForm
  include ActiveModel::Model

  attr_reader :appointment_id

  validates :appointment_id, presence: true

  def initialize(hash = {})
    @appointment_id = hash[:appointment_id]
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
end
