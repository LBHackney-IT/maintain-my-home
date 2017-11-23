class AppointmentPresenter
  include ActiveSupport::Inflector

  def initialize(appointment = {})
    @appointment = appointment
  end

  def appointment_id
    [
      @appointment.fetch('beginDate'),
      @appointment.fetch('endDate'),
    ].join('|')
  end

  def description
    "#{day_of_week} #{begin_time}-#{end_time} (#{day} #{month})"
  end

  def date
    "#{day_of_week} #{day} #{month}"
  end

  def time
    [begin_time, end_time].to_sentence
  end

  def to_partial_path
    '/confirmations/appointment'
  end

  private

  def begin_date
    Time.zone.parse(@appointment.fetch('beginDate'))
  end

  def end_date
    Time.zone.parse(@appointment.fetch('endDate'))
  end

  def day_of_week
    I18n.l(begin_date, format: '%A')
  end

  def month
    I18n.l(begin_date, format: '%B')
  end

  def day
    ordinalize(begin_date.day)
  end

  def begin_time
    friendly_time(begin_date)
  end

  def end_time
    friendly_time(end_date)
  end

  def friendly_time(time)
    return 'midday' if time == time.midday
    format = if time.strftime('%M').to_i.zero?
               '%l%P'
             else
               '%l:%M%P'
             end

    I18n.l(time, format: format).strip
  end
end
