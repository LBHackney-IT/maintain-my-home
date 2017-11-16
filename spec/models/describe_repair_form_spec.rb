require 'spec_helper'
require 'active_model'
require 'app/models/describe_repair_form'

RSpec.describe DescribeRepairForm do
  describe 'validations' do
    it 'is valid without a description' do
      form = DescribeRepairForm.new
      expect(form).to be_valid
    end

    it 'is valid with a description' do
      form = DescribeRepairForm.new(description: 'my taps are leaking')
      expect(form).to be_valid
    end

    it 'is invalid with an overly long description' do
      form = DescribeRepairForm.new(description: ('X' * 501))
      form.valid?

      expect(form.errors.details[:description])
        .to include(error: :too_long, count: 500)
    end
  end
end
