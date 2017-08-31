require 'rails_helper'

RSpec.describe Authentication do
  controller(ActionController::Base) do
    include Authentication

    def index
      head :ok
    end
  end

  describe '#authenticate' do
    it 'allows access if HTTP basic auth environment variables not set' do
      get :index

      expect(response).to have_http_status :ok
    end

    context 'with HTTP basic auth enabled' do
      around(:each) do |example|
        ClimateControl.modify(HTTP_AUTH_USER: 'user', HTTP_AUTH_PASSWORD: 'letmein') do
          example.run
        end
      end

      it 'returns HTTP 401 if username and password required' do
        get :index

        expect(response).to have_http_status :unauthorized
      end

      it 'returns HTTP 200 if username and password are correct' do
        set_request_auth_headers!('user', 'letmein')
        get :index

        expect(response).to have_http_status :ok
      end

      it 'returns HTTP 401 if username or password are incorrect' do
        set_request_auth_headers!('user', 'wrong')
        get :index

        expect(response).to have_http_status :unauthorized
      end
    end

    private

    def set_request_auth_headers!(username, password)
      encoded_credentials = ActionController::HttpAuthentication::Basic.encode_credentials(username, password)
      request.env['HTTP_AUTHORIZATION'] = encoded_credentials
    end
  end
end
