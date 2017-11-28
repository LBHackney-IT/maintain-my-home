require 'rails_helper'

RSpec.describe AppointmentForm do
  describe 'validations' do
    it 'is invalid when an appointment not chosen' do
      form = AppointmentForm.new
      form.valid?

      expect(form.errors.details[:appointment_id]).to include(error: :blank)
    end
  end

  describe '#begin_date'  do
    it 'is extracted from the appointment_id parameter' do
      ClimateControl.modify(ENCRYPTION_SECRET: 'test') do
        appointment = { 'beginDate' => '2017-11-09T10:00:00Z' }
        input = { appointment_id: appointment }

        fake_message_verifier_instance = instance_double('ActiveSupport::MessageVerifier')
        expect(fake_message_verifier_instance).to receive(:verify)
          .and_return(appointment)

        fake_message_verifier = class_double('ActiveSupport::MessageVerifier')
        expect(fake_message_verifier).to receive(:new)
          .with('test')
          .and_return(fake_message_verifier_instance)

        expect(AppointmentForm.new(input, verifier: fake_message_verifier).begin_date)
          .to eql '2017-11-09T10:00:00Z'
      end
    end

    it 'raises an error if it has been tampered with' do
      ClimateControl.modify(ENCRYPTION_SECRET: 'test') do
        appointment = { 'beginDate' => '2017-11-09T10:00:00Z' }
        input = { appointment_id: appointment }

        fake_message_verifier_instance = instance_double('ActiveSupport::MessageVerifier')
        expect(fake_message_verifier_instance).to receive(:verify)
          .and_raise('ActiveSupport::MessageVerifier::InvalidSignature')

        fake_message_verifier = class_double('ActiveSupport::MessageVerifier')
        expect(fake_message_verifier).to receive(:new)
          .with('test')
          .and_return(fake_message_verifier_instance)

        expect { AppointmentForm.new(input, verifier: fake_message_verifier).end_date }
          .to raise_error('ActiveSupport::MessageVerifier::InvalidSignature')
      end
    end
  end

  describe '#end_date' do
    it 'is extracted from the appointment_id parameter' do
      ClimateControl.modify(ENCRYPTION_SECRET: 'test') do
        appointment = { 'endDate' => '2017-11-09T12:00:00Z' }
        input = { appointment_id: appointment }

        fake_message_verifier_instance = instance_double('ActiveSupport::MessageVerifier')
        expect(fake_message_verifier_instance).to receive(:verify)
          .and_return(appointment)

        fake_message_verifier = class_double('ActiveSupport::MessageVerifier')
        expect(fake_message_verifier).to receive(:new)
          .with('test')
          .and_return(fake_message_verifier_instance)

        expect(AppointmentForm.new(input, verifier: fake_message_verifier).end_date)
          .to eql '2017-11-09T12:00:00Z'
      end
    end

    it 'raises an error if it has been tampered with' do
      ClimateControl.modify(ENCRYPTION_SECRET: 'test') do
        appointment = { 'endDate' => '2017-11-09T12:00:00Z' }
        input = { appointment_id: appointment }

        fake_message_verifier_instance = instance_double('ActiveSupport::MessageVerifier')
        expect(fake_message_verifier_instance).to receive(:verify)
          .and_raise('ActiveSupport::MessageVerifier::InvalidSignature')

        fake_message_verifier = class_double('ActiveSupport::MessageVerifier')
        expect(fake_message_verifier).to receive(:new)
          .with('test')
          .and_return(fake_message_verifier_instance)

        expect { AppointmentForm.new(input, verifier: fake_message_verifier).end_date }
          .to raise_error('ActiveSupport::MessageVerifier::InvalidSignature')
      end
    end
  end
end
