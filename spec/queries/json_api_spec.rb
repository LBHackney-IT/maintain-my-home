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

      it 'parses a JSON response with an unspecified content_type' do
        json_api = JsonApi.new(api_root: 'http://hackney.api:8000')
        stub_request(:get, 'http://hackney.api:8000/properties?postcode=A1%201AA')
          .to_return(
            body: [{ 'property_reference' => 'abc123', 'short_address' => '1 some road' }].to_json
          )

        result = json_api.get('properties?postcode=A1 1AA')

        expect(result).to eq [{ 'property_reference' => 'abc123', 'short_address' => '1 some road' }]
      end

      it 'raises an exception for an invalid json response' do
        json_api = JsonApi.new(api_root: 'http://hackney.api:8000')
        stub_request(:get, 'http://hackney.api:8000/properties?postcode=A1%201AA')
          .to_return(
            body: '<html><body>An error occurred</body></html>'
          )

        expect { json_api.get('properties?postcode=A1 1AA') }
          .to raise_error(JsonApi::InvalidResponseError, "765: unexpected token at '<html><body>An error occurred</body></html>'")
      end

      it 'handles an empty response body' do
        json_api = JsonApi.new(api_root: 'http://hackney.api:8000')
        stub_request(:get, 'http://hackney.api:8000/properties?postcode=A1%201AA')

        result = json_api.get('properties?postcode=A1 1AA')

        expect(result).to eq nil
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

  describe '#post' do
    it 'sends a JSON payload' do
      json_api = JsonApi.new(api_root: 'http://hackney.api:8000')
      request_params = { priority: 'N', problem: 'It is broken', property_reference: '00001234' }
      request_json = request_params.to_json
      stub_request(:post, 'http://hackney.api:8000/repairs')
        .with(body: request_json)

      json_api.post('repairs', request_params)

      expect(a_request(:post, 'http://hackney.api:8000/repairs')
        .with(
          body: request_json,
          headers: { content_type: 'application/json' }
        )).to have_been_made.once
    end

    it 'parses a JSON response' do
      json_api = JsonApi.new(api_root: 'http://hackney.api:8000')
      response_params = { repair_request_id: '00045678' }
      stub_request(:post, 'http://hackney.api:8000/repairs')
        .to_return(body: response_params.to_json)

      result = json_api.post('repairs', {})
      expect(result).to eq('repair_request_id' => '00045678')
    end

    context 'when the response was not valid JSON' do
      it 'raises an exception' do
        json_api = JsonApi.new(api_root: 'http://hackney.api:8000')
        stub_request(:post, 'http://hackney.api:8000/repairs')
          .to_return(body: 'not found')

        expect { json_api.post('/repairs', {}) }
          .to raise_error(JsonApi::InvalidResponseError, "765: unexpected token at 'not found'")
      end
    end
  end
end
