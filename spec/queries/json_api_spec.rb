require 'spec_helper'
require 'faraday_middleware'
require 'app/queries/json_api'
require 'active_support/core_ext/object/blank'

RSpec.describe JsonApi do
  describe '#get' do
    context 'with a path matching properties?postcode=' do
      it 'parses a JSON response' do
        json_api = JsonApi.new(api_root: 'http://hackney.api:8000')
        stub_request(:get, 'http://hackney.api:8000/properties?postcode=A1%201AA')
          .to_return(
            body: [{ 'property_reference' => 'abc123', 'short_address' => '1 some road' }].to_json,
            headers: { content_type: 'application/json' }
          )

        result = json_api.get('properties?postcode=A1 1AA')

        expect(result).to eq [{ 'property_reference' => 'abc123', 'short_address' => '1 some road' }]
      end
    end

    context 'with a path matching properties/:property_reference' do
      it 'parses a JSON response' do
        json_api = JsonApi.new(api_root: 'http://hackney.api:8000')
        stub_request(:get, 'http://hackney.api:8000/properties/zxc098')
          .to_return(
            body: { 'uprn' => 'xyz987', 'property_reference' => 'abc123', 'short_address' => '1 some road' }.to_json,
            headers: { content_type: 'application/json' }
          )

        result = json_api.get('properties/zxc098')

        expect(result).to eq('uprn' => 'xyz987', 'property_reference' => 'abc123', 'short_address' => '1 some road')
      end
    end

    context 'when the api root is missing' do
      it 'raises an exception' do
        expect { JsonApi.new(api_root: nil) }
          .to raise_error(JsonApi::InvalidApiRootError)
      end
    end

    context 'when the api root is empty' do
      it 'raises an exception' do
        expect { JsonApi.new(api_root: '') }
          .to raise_error(JsonApi::InvalidApiRootError)
      end
    end

    context 'when the api root is only whitespace' do
      it 'raises an exception' do
        expect { JsonApi.new(api_root: '  ') }
          .to raise_error(JsonApi::InvalidApiRootError)
      end
    end
  end
end
