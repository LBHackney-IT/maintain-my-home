require 'spec_helper'
require 'faraday_middleware'
require 'app/queries/json_api'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/hash/slice'
require 'rack-timeout'
require 'logger'
require 'spec/support/test_ssl'

RSpec.describe JsonApi do
  before do
    dev_null = File.new('/dev/null', 'w')
    null_logger = Logger.new(dev_null)
    stub_const('Rails', double(logger: null_logger))
  end

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
  end

  describe '#get' do
    it 'adds the API token to the header of the request' do
      cached_api_token = ENV['HACKNEY_API_TOKEN']
      ENV['HACKNEY_API_TOKEN'] = 'foobar'

      stub_request(:get, 'http://hackney.api:8000/properties?postcode=A1%201AA')

      json_api = JsonApi.new(api_root: 'http://hackney.api:8000')

      json_api.get('properties?postcode=A1 1AA')

      expect(a_request(:get, 'http://hackney.api:8000/properties?postcode=A1%201AA')
        .with(
          headers: {
            'X-Api-Key' => 'foobar',
          }
        )).to have_been_made.once

      ENV['HACKNEY_API_TOKEN'] = cached_api_token
    end

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

    context 'when the connection failed' do
      it 'raises an error' do
        json_api = JsonApi.new(api_root: 'http://hackney.api:8000')
        stub_request(:get, 'http://hackney.api:8000/properties?postcode=A1%201AA').to_timeout

        expect { json_api.get('properties?postcode=A1 1AA') }
          .to raise_error(JsonApi::ConnectionError)
      end
    end

    context 'when the request took too long' do
      it 'raises an error' do
        json_api = JsonApi.new(api_root: 'http://hackney.api:8000')
        stub_request(:get, 'http://hackney.api:8000/properties?postcode=A1%201AA')
          .to_raise(Rack::Timeout::RequestTimeoutException)

        expect { json_api.get('properties?postcode=A1 1AA') }
          .to raise_error(JsonApi::TimeoutError)
      end
    end

    context 'when the response is a 404 status' do
      it 'raises an error' do
        json_api = JsonApi.new(api_root: 'http://hackney.api:8000')
        stub_request(:get, 'http://hackney.api:8000/properties?postcode=A1%201AA')
          .to_return(
            status: 404,
            body: nil.to_json
          )
        expect { json_api.get('properties?postcode=A1 1AA') }
          .to raise_error(JsonApi::StatusNotFoundError)
      end
    end

    context 'when the response is a 400 status' do
      it 'raises an error' do
        json_api = JsonApi.new(api_root: 'http://hackney.api:8000')
        stub_request(:get, 'http://hackney.api:8000/properties?postcode=A1%201AA')
          .to_return(
            status: 400,
            body: { 'errors' => { 'userMessage' => 'That was invalid', 'developerMessage' => 'invalid request' } }.to_json
          )
        expect { json_api.get('properties?postcode=A1 1AA') }
          .to raise_error(JsonApi::StatusBadRequestError, 'invalid request')
      end
    end

    context 'when the response is a 500 status' do
      it 'raises an error' do
        json_api = JsonApi.new(api_root: 'http://hackney.api:8000')
        stub_request(:get, 'http://hackney.api:8000/properties?postcode=A1%201AA')
          .to_return(
            status: 500,
            body: { 'errors' => { 'userMessage' => 'Something is wrong', 'developerMessage' => 'server error' } }.to_json
          )
        expect { json_api.get('properties?postcode=A1 1AA') }
          .to raise_error(JsonApi::StatusServerError, 'server error')
      end
    end

    context 'when the response is an unexpected status' do
      it 'raises an error' do
        json_api = JsonApi.new(api_root: 'http://hackney.api:8000')
        stub_request(:get, 'http://hackney.api:8000/properties?postcode=A1%201AA')
          .to_return(
            status: 503,
            body: { 'errors' => { 'userMessage' => 'Something is wrong', 'developerMessage' => 'server error' } }.to_json
          )
        expect { json_api.get('properties?postcode=A1 1AA') }
          .to raise_error(JsonApi::StatusUnexpectedError, 'server error')
      end
    end

    context 'when the response error json is in the wrong format (array)' do
      context 'when the response is a 400 status' do
        it 'raises an error' do
          json_api = JsonApi.new(api_root: 'http://hackney.api:8000')
          stub_request(:get, 'http://hackney.api:8000/properties?postcode=A1%201AA')
            .to_return(
              status: 400,
              body: [{ 'userMessage' => 'That was invalid', 'developerMessage' => 'invalid request' }].to_json
            )
          expect { json_api.get('properties?postcode=A1 1AA') }
            .to raise_error(JsonApi::StatusBadRequestError, 'invalid request')
        end
      end

      context 'when the response is a 400 status with multiple validation errors' do
        it 'raises an error' do
          json_api = JsonApi.new(api_root: 'http://hackney.api:8000')
          stub_request(:post, 'http://hackney.api:8000/repairs')
            .to_return(
              status: 400,
              body: [
                { 'userMessage' => 'Phone number is missing', 'developerMessage' => 'Phone number cannot be blank' },
                { 'userMessage' => 'Description is missing', 'developerMessage' => 'Description cannot be blank' },
              ].to_json
            )
          expect { json_api.post('repairs', {}) }
            .to raise_error(JsonApi::StatusBadRequestError, 'Phone number cannot be blank, Description cannot be blank')
        end
      end

      context 'when the response is a 500 status' do
        it 'raises an error' do
          json_api = JsonApi.new(api_root: 'http://hackney.api:8000')
          stub_request(:get, 'http://hackney.api:8000/properties?postcode=A1%201AA')
            .to_return(
              status: 500,
              body: [{ 'userMessage' => 'Something is wrong', 'developerMessage' => 'server error' }].to_json
            )
          expect { json_api.get('properties?postcode=A1 1AA') }
            .to raise_error(JsonApi::StatusServerError, 'server error')
        end
      end

      context 'when the response is an unexpected status' do
        it 'raises an error' do
          json_api = JsonApi.new(api_root: 'http://hackney.api:8000')
          stub_request(:get, 'http://hackney.api:8000/properties?postcode=A1%201AA')
            .to_return(
              status: 503,
              body: [{ 'userMessage' => 'Something is wrong', 'developerMessage' => 'server error' }].to_json
            )
          expect { json_api.get('properties?postcode=A1 1AA') }
            .to raise_error(JsonApi::StatusUnexpectedError, 'server error')
        end
      end
    end

    context 'when the response error json is in the wrong format (no key)' do
      context 'when the response is a 500 status' do
        it 'raises an error' do
          json_api = JsonApi.new(api_root: 'http://hackney.api:8000')
          stub_request(:get, 'http://hackney.api:8000/properties?postcode=A1%201AA')
            .to_return(
              status: 500,
              body: { 'userMessage' => 'Something is wrong', 'developerMessage' => 'server error' }.to_json
            )
          expect { json_api.get('properties?postcode=A1 1AA') }
            .to raise_error(JsonApi::StatusServerError, 'server error')
        end
      end

      context 'when the response is an unexpected status' do
        it 'raises an error' do
          json_api = JsonApi.new(api_root: 'http://hackney.api:8000')
          stub_request(:get, 'http://hackney.api:8000/properties?postcode=A1%201AA')
            .to_return(
              status: 503,
              body: { 'userMessage' => 'Something is wrong', 'developerMessage' => 'server error' }.to_json
            )
          expect { json_api.get('properties?postcode=A1 1AA') }
            .to raise_error(JsonApi::StatusUnexpectedError, 'server error')
        end
      end
    end

    context 'when a client certificate is specified' do
      # TODO: work out how to test that the certificate and api_key actually get used

      it 'makes a valid request' do
        json_api = JsonApi.new(
          api_root: 'http://hackney.api:8000',
        )
        stub_request(:get, 'http://hackney.api:8000/hackneyrepairs/v1/repairs/00012345')

        json_api.get('hackneyrepairs/v1/repairs/00012345')

        expect(a_request(:get, 'http://hackney.api:8000/hackneyrepairs/v1/repairs/00012345'))
          .to have_been_made.once
      end
    end
  end

  describe '#post' do
    it 'adds the API token to the header of the request' do
      cached_api_token = ENV['HACKNEY_API_TOKEN']
      ENV['HACKNEY_API_TOKEN'] = 'foobar'

      stub_request(:post, "http://hackney.api:8000/hackneyrepairs/v1/repairs")

      json_api = JsonApi.new(api_root: 'http://hackney.api:8000')

      json_api.post('hackneyrepairs/v1/repairs', {})

      expect(a_request(:post, 'http://hackney.api:8000/hackneyrepairs/v1/repairs')
        .with(
          headers: {
            content_type: 'application/json',
            'X-Api-Key' => 'foobar',
          }
        )).to have_been_made.once

      ENV['HACKNEY_API_TOKEN'] = cached_api_token
    end

    it 'sends a JSON payload' do
      json_api = JsonApi.new(api_root: 'http://hackney.api:8000')
      request_params = { priority: 'N', problemDescription: 'It is broken', propertyReference: '00001234' }
      request_json = request_params.to_json
      stub_request(:post, 'http://hackney.api:8000/hackneyrepairs/v1/repairs')
        .with(body: request_json)

      json_api.post('hackneyrepairs/v1/repairs', request_params)

      expect(a_request(:post, 'http://hackney.api:8000/hackneyrepairs/v1/repairs')
        .with(
          body: request_json,
          headers: { content_type: 'application/json' }
        )).to have_been_made.once
    end

    it 'parses a JSON response' do
      json_api = JsonApi.new(api_root: 'http://hackney.api:8000')
      response_params = { repair_request_id: '00045678' }
      stub_request(:post, 'http://hackney.api:8000/hackneyrepairs/v1/repairs')
        .to_return(body: response_params.to_json)

      result = json_api.post('hackneyrepairs/v1/repairs', {})
      expect(result).to eq('repair_request_id' => '00045678')
    end

    context 'when the response was not valid JSON' do
      it 'raises an exception' do
        json_api = JsonApi.new(api_root: 'http://hackney.api:8000')
        stub_request(:post, 'http://hackney.api:8000/hackneyrepairs/v1/repairs')
          .to_return(body: 'not found')

        expect { json_api.post('/hackneyrepairs/v1/repairs', {}) }
          .to raise_error(JsonApi::InvalidResponseError, "765: unexpected token at 'not found'")
      end
    end

    it 'raises an error when the connection failed' do
      json_api = JsonApi.new(api_root: 'http://hackney.api:8000')
      stub_request(:post, 'http://hackney.api:8000/repairs').to_timeout

      expect { json_api.post('/repairs', {}) }
        .to raise_error(JsonApi::ConnectionError)
    end
  end
end
