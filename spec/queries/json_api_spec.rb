require 'spec_helper'
require 'app/queries/json_api'

RSpec.describe JsonApi do
  describe '#get' do
    it 'does not raise an error' do
      json_api = JsonApi.new

      expect { json_api.get('asfasf') }.not_to raise_error
    end

    context 'with a path matching properties?postcode=' do
      it 'returns a valid response' do
        json_api = JsonApi.new

        result = json_api.get('properties?postcode=A1 1AA')

        expect(result).to be_an(Array)
        expect(result.first.keys).to include('property_reference', 'short_address')
      end
    end

    context 'with a path matching properties/:property_reference' do
      it 'returns a valid response' do
        json_api = JsonApi.new

        result = json_api.get('properties/zxc098')

        expect(result).to be_a(Hash)
        expect(result.keys).to include('property_reference', 'short_address', 'uprn')
      end
    end
  end
end
