require 'spec_helper'
require 'active_model'
require 'app/models/description_form'

RSpec.describe DescriptionForm do
  describe 'validations' do
    it 'is valid without a description' do
      expect(DescriptionForm.new.valid?).to eq true
    end

    it 'is valid with a description' do
      expect(DescriptionForm.new(description: 'my taps are leaking').valid?).to eq true
    end
  end
end
