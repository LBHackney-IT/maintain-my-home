require 'spec_helper'
require 'faraday_middleware'
require 'app/queries/json_api'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/hash/slice'
require 'spec/support/test_ssl'

RSpec.describe JsonApi do
  describe 'construction' do
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

    context 'when a certificate is provided' do
      it 'raises an error if the private key was missing' do
        expect do
          JsonApi.new(
            api_root: 'http://hackney.api:8000',
            api_cert: TestSsl.certificate,
            api_key: nil,
          )
        end.to raise_error JsonApi::MissingPrivateKeyError
      end

      it 'raises an error if the private key was invalid' do
        expect do
          JsonApi.new(
            api_root: 'http://hackney.api:8000',
            api_cert: TestSsl.certificate,
            api_key: 'Not a key'
          )
        end.to raise_error OpenSSL::PKey::RSAError
      end

      it 'raises an error if the cert was invalid' do
        expect do
          JsonApi.new(
            api_root: 'http://hackney.api:8000',
            api_cert: 'Not a cert',
            api_key: TestSsl.key
          )
        end.to raise_error OpenSSL::X509::CertificateError
      end
    end
  end

  describe '#get' do
    it 'parses a JSON response' do
      json_api = JsonApi.new(api_root: 'http://hackney.api:8000')
      stub_request(:get, 'http://hackney.api:8000/properties?postcode=A1%201AA')
        .to_return(
          body: [{ 'propertyReference' => 'abc123', 'address' => '1 some road', 'postcode' => 'A1 1AA' }].to_json,
          headers: { content_type: 'application/json' }
        )

      result = json_api.get('properties?postcode=A1 1AA')

      expect(result).to eq [{ 'propertyReference' => 'abc123', 'address' => '1 some road', 'postcode' => 'A1 1AA' }]
    end

    it 'parses a JSON response with an unspecified content_type' do
      json_api = JsonApi.new(api_root: 'http://hackney.api:8000')
      stub_request(:get, 'http://hackney.api:8000/properties?postcode=A1%201AA')
        .to_return(
          body: [{ 'propertyReference' => 'abc123', 'address' => '1 some road', 'postcode' => 'A1 1AA' }].to_json
        )

      result = json_api.get('properties?postcode=A1 1AA')

      expect(result).to eq [{ 'propertyReference' => 'abc123', 'address' => '1 some road', 'postcode' => 'A1 1AA' }]
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

    context 'when a client certificate is specified' do
      # TODO: work out how to test that the certificate and api_key actually get used

      it 'makes a valid request' do
        json_api = JsonApi.new(
          api_root: 'http://hackney.api:8000',
          api_cert: TestSsl.certificate,
          api_key: TestSsl.key,
        )
        stub_request(:get, 'http://hackney.api:8000/v1/repairs/00012345')

        json_api.get('v1/repairs/00012345')

        expect(a_request(:get, 'http://hackney.api:8000/v1/repairs/00012345'))
          .to have_been_made.once
      end
    end
  end

  describe '#post' do
    it 'sends a JSON payload' do
      json_api = JsonApi.new(api_root: 'http://hackney.api:8000')
      request_params = { priority: 'N', problemDescription: 'It is broken', propertyReference: '00001234' }
      request_json = request_params.to_json
      stub_request(:post, 'http://hackney.api:8000/v1/repairs')
        .with(body: request_json)

      json_api.post('v1/repairs', request_params)

      expect(a_request(:post, 'http://hackney.api:8000/v1/repairs')
        .with(
          body: request_json,
          headers: { content_type: 'application/json' }
        )).to have_been_made.once
    end

    it 'parses a JSON response' do
      json_api = JsonApi.new(api_root: 'http://hackney.api:8000')
      response_params = { repair_request_id: '00045678' }
      stub_request(:post, 'http://hackney.api:8000/v1/repairs')
        .to_return(body: response_params.to_json)

      result = json_api.post('v1/repairs', {})
      expect(result).to eq('repair_request_id' => '00045678')
    end

    context 'when the response was not valid JSON' do
      it 'raises an exception' do
        json_api = JsonApi.new(api_root: 'http://hackney.api:8000')
        stub_request(:post, 'http://hackney.api:8000/v1/repairs')
          .to_return(body: 'not found')

        expect { json_api.post('/v1/repairs', {}) }
          .to raise_error(JsonApi::InvalidResponseError, "765: unexpected token at 'not found'")
      end
    end
  end
end
