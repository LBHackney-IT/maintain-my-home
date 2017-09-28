require 'spec_helper'
require 'app/queries/fake_json_api'

RSpec.describe FakeJsonApi do
  describe '#get' do
    context 'with a path matching properties?postcode=' do
      it 'returns a valid response' do
        json_api = FakeJsonApi.new

        result = json_api.get('properties?postcode=A1 1AA')

        expect(result).to be_an(Array)
        expect(result.first.keys).to include('property_reference', 'short_address')
      end
    end

    context 'with a path matching properties/:property_reference' do
      it 'returns a valid response' do
        json_api = FakeJsonApi.new

        result = json_api.get('properties/zxc098')

        expect(result).to be_a(Hash)
        expect(result.keys).to include('property_reference', 'short_address', 'uprn')
      end
    end
  end
end
