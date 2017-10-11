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
  end
end
