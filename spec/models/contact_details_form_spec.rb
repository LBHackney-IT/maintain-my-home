require 'rails_helper'

RSpec.describe ContactDetailsForm do
  describe 'validations' do
    it 'is valid when the required parameters are provided' do
      form = ContactDetailsForm.new(
        full_name: 'Robin Hood',
        telephone_number: '0115 123 4567',
      )

      expect(form).to be_valid
    end

    it 'is invalid when full_name is blank' do
      form = ContactDetailsForm.new
      form.valid?

      expect(form.errors.details[:full_name]).to include(error: :blank)
    end

    it 'is invalid when full_name is less than 2 characters long' do
      form = ContactDetailsForm.new(full_name: 'x')
      form.valid?

      expect(form.errors.details[:full_name]).to include(error: :too_short, count: 2)
    end

    it 'is invalid when telephone_number is blank' do
      form = ContactDetailsForm.new
      form.valid?

      expect(form.errors.details[:telephone_number]).to include(error: :blank)
    end
  end
end
