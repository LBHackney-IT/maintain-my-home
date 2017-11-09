require 'rails_helper'

RSpec.describe AppointmentForm do
  describe 'validations' do
    it 'is invalid when an appointment not chosen' do
      form = AppointmentForm.new
      form.valid?

      expect(form.errors.details[:appointment_id]).to include(error: :blank)
    end

    it 'raises an exception if appointment_id does not contain two dates' do
      input = { appointment_id: '2017-12-25:12:34:56Z' }

      expect { AppointmentForm.new(input) }
        .to raise_error(AppointmentForm::InvalidAppointment)
    end

    it 'raises an exception if appointment_id is not formatted correctly' do
      input = { appointment_id: 'invalid|2017-12-25:10:10:10Z' }

      expect { AppointmentForm.new(input) }
        .to raise_error(AppointmentForm::InvalidAppointment)
    end
  end

  describe '#begin_date'  do
    it 'is extracted from the appointment_id parameter' do
      input = { appointment_id: '2017-11-09T10:00:00Z|2017-11-09T12:00:00Z' }

      expect(AppointmentForm.new(input).begin_date).to eql '2017-11-09T10:00:00Z'
    end
  end

  describe '#end_date' do
    it 'is extracted from the appointment_id parameter' do
      input = { appointment_id: '2017-11-09T10:00:00Z|2017-11-09T12:00:00Z' }

      expect(AppointmentForm.new(input).end_date).to eql '2017-11-09T12:00:00Z'
    end
  end
end
