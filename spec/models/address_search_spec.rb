require 'spec_helper'
require 'active_model'
require 'app/models/address_search'

RSpec.describe AddressSearch do
  describe '.data' do
    it 'returns the search data as a hash' do
      params = { postcode: 'N16 8QR' }
      expect(AddressSearch.new(params).data).to eq(postcode: 'N16 8QR')
    end
  end
end
