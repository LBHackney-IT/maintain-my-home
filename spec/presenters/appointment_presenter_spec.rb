require 'rails_helper'

RSpec.describe AppointmentPresenter do
  it 'is renderable' do
    expect(AppointmentPresenter.new.to_partial_path).to eq '/confirmations/appointment'
  end

  describe '#appointment_id' do
    it 'returns the appointment in tamperproof format' do
      ClimateControl.modify(ENCRYPTION_SECRET: 'test') do
        appointment = {
          'beginDate' => '2017-12-25T12:00:00Z',
          'endDate' => '2017-12-25T16:45:00Z',
          'bestSlot' => true,
        }

        fake_message_verifier_instance = instance_double('ActiveSupport::MessageVerifier')
        expect(fake_message_verifier_instance).to receive(:generate)
          .and_return('encrypted_appointment')

        fake_message_verifier = class_double('ActiveSupport::MessageVerifier')
        expect(fake_message_verifier).to receive(:new)
          .and_return(fake_message_verifier_instance)

        presenter = AppointmentPresenter.new(appointment, verifier: fake_message_verifier)

        expect(presenter.appointment_id).to eql 'encrypted_appointment'
      end
    end
  end

  describe '#description' do
    it 'returns the appointment in a human-readable format' do
      presenter = AppointmentPresenter.new(
        'beginDate' => '2017-12-25T12:15:00Z',
        'endDate' => '2017-12-25T16:45:00Z',
        'bestSlot' => true
      )

      expect(presenter.description).to eql 'Monday 12:15pm to 4:45pm (25th December)'
    end

    it 'returns times on the hour without :00' do
      presenter = AppointmentPresenter.new(
        'beginDate' => '2017-12-25T13:00:00Z',
        'endDate' => '2017-12-25T16:00:00Z',
        'bestSlot' => true
      )

      expect(presenter.description).to eql 'Monday 1pm to 4pm (25th December)'
    end
  end

  describe '#date' do
    it 'returns the appointment date in a format suitable for the confirmation page' do
      presenter = AppointmentPresenter.new(
        'beginDate' => '2017-12-25T12:00:00Z',
        'endDate' => '2017-12-25T16:45:00Z',
        'bestSlot' => true
      )

      expect(presenter.date).to eql 'Monday 25th December'
    end
  end

  describe '#time' do
    it 'returns the appointment times in a format suitable for the confirmation page' do
      presenter = AppointmentPresenter.new(
        'beginDate' => '2017-12-25T12:00:00Z',
        'endDate' => '2017-12-25T16:45:00Z',
        'bestSlot' => true
      )

      expect(presenter.time).to eql 'midday and 4:45pm'
    end
  end
end
