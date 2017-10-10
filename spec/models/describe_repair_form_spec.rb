require 'spec_helper'
require 'active_model'
require 'app/models/describe_repair_form'

RSpec.describe DescribeRepairForm do
  describe 'validations' do
    it 'is valid without a description' do
      expect(DescribeRepairForm.new.valid?).to eq true
    end

    it 'is valid with a description' do
      expect(DescribeRepairForm.new(description: 'my taps are leaking').valid?).to eq true
    end
  end
end
