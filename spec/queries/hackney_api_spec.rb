require 'spec_helper'
require 'app/queries/hackney_api'

describe HackneyApi do
  describe '#list_properties' do
    it 'returns a list of properties' do
      results = [
        { 'property_reference' => 'def567', 'short_address' => 'Flat 8, 1 Aardvark Road, A1 1AA' },
      ]
      json_api = double(get: results)
      api = HackneyApi.new(json_api)

      expect(api.list_properties(postcode: 'A1 1AA')).to eql results
    end
  end

  describe '#get_property' do
    it 'returns an individual property' do
      results = {
        'property_reference' => 'cre045',
        'short_address' => 'Flat 45, Cheddar Row Estate, Hackney, N1 1AA',
      }
      json_api = instance_double('JsonApi')
      allow(json_api).to receive(:get).with('properties/cre045').and_return(results)
      api = HackneyApi.new(json_api)

      expect(api.get_property(property_reference: 'cre045')).to eql results
    end
  end
end
