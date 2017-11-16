require 'rails_helper'

RSpec.describe DescribeUnknownRepairForm do
  describe 'validations' do
    it 'is valid with a description' do
      form = DescribeUnknownRepairForm.new(description: 'It is broken')

      expect(form).to be_valid
    end

    it 'is invalid without a description' do
      form = DescribeUnknownRepairForm.new
      form.valid?

      expect(form.errors.details[:description]).to include(error: :blank)
    end

    it 'is invalid with an overly long description' do
      form = DescribeUnknownRepairForm.new(description: ('X' * 201))
      form.valid?

      expect(form.errors.details[:description]).to include(error: :too_long, count: 500)
    end
  end
end
