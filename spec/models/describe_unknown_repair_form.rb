require 'rails_helper'

RSpec.describe DescribeUnknownRepairForm do
  describe 'validations' do
    it '.description' do
      form = DescribeUnknownRepairForm.new
      form.valid?

      expect(form.errors.details[:description]).to include(error: :blank)
    end
  end
end
