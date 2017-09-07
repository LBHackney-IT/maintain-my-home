require 'spec_helper'
require 'app/queries/address_finder'

RSpec.describe AddressFinder do
  describe '.find' do
    it 'returns some hardcoded data' do
      expect(AddressFinder.new.find(double)).to eq [['P01234', 'Flat 1, 8 Hoxton Square, N1 6NU']]
    end
  end
end
