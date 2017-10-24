require 'rails_helper'

RSpec.describe ContactDetailsWithCallbackForm do
  describe 'validations' do
    it 'is invalid when full_name is blank' do
      form = ContactDetailsWithCallbackForm.new
      form.valid?

      expect(form.errors.details[:full_name]).to include(error: :blank)
    end

    it 'is invalid when telephone_number is blank' do
      form = ContactDetailsWithCallbackForm.new
      form.valid?

      expect(form.errors.details[:telephone_number]).to include(error: :blank)
    end

    it 'is invalid when callback_time is blank' do
      form = ContactDetailsWithCallbackForm.new
      form.valid?

      expect(form.errors.details[:callback_time]).to include(error: :blank)
    end

    it 'is valid when the required parameters are provided' do
      form = ContactDetailsWithCallbackForm.new(
        full_name: 'Robin Hood',
        telephone_number: '0115 123 4567',
        callback_time: :afternoon
      )

      expect(form).to be_valid
    end
  end
end
