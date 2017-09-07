require 'spec_helper'
require 'app/queries/address_finder'

RSpec.describe AddressFinder do
  describe '.find' do
    it 'returns some hardcoded data' do
      result = AddressFinder.new.find(double)
      expect(result.first.property_reference).to eq 'P01234'
      expect(result.first.short_address).to eq 'Flat 1, 8 Hoxton Square, N1 6NU'
    end
  end
end
