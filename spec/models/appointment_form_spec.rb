require 'rails_helper'

RSpec.describe AppointmentForm do
  describe 'validations' do
    it 'is invalid when an appointment not chosen' do
      form = AppointmentForm.new
      form.valid?

      expect(form.errors.details[:appointment_id]).to include(error: :blank)
    end
  end
end
