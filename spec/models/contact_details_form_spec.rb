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

    describe '.full_name' do
      it 'is invalid when blank' do
        form = ContactDetailsForm.new
        form.valid?

        expect(form.errors.details[:full_name]).to include(error: :blank)
      end

      it 'is invalid when less than 2 characters long' do
        form = ContactDetailsForm.new(full_name: 'x')
        form.valid?

        expect(form.errors.details[:full_name]).to include(error: :too_short, count: 2)
      end
    end

    describe '.telephone_number' do
      it 'is invalid when blank' do
        form = ContactDetailsForm.new
        form.valid?

        expect(form.errors.details[:telephone_number]).to include(error: :blank)
      end

      it 'is invalid when too short' do
        form = ContactDetailsForm.new(telephone_number: '012345678')
        form.valid?

        expect(form.errors.details[:telephone_number]).to include(error: :too_short, count: 10)
      end

      it 'is invalid when too long' do
        form = ContactDetailsForm.new(telephone_number: '079001234560')
        form.valid?

        expect(form.errors.details[:telephone_number]).to include(error: :too_long, count: 11)
      end

      it 'only counts digits towards the length limit' do
        form = ContactDetailsForm.new(telephone_number: ' (01234) 567890    ')
        form.valid?

        expect(form.errors.details[:telephone_number]).to be_empty
      end
    end
  end
end
