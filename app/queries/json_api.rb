class JsonApi
  class Error < StandardError; end
  class InvalidApiRootError < Error; end
  class MissingPrivateKeyError < Error; end
  class InvalidResponseError < Error; end
  class ConnectionError < Error; end

  def initialize(api_config = {})
    @connection = ConnectionBuilder.new.build(api_config)
  end

  def get(path)
    response = call_and_raise do
      @connection.get(path)
    end
    response.body
  end

  def post(path, params)
    response = call_and_raise do
      @connection.post(path) do |request|
        request.body = params.to_json
        request.headers['Content-Type'] = 'application/json'
      end
    end
    response.body
  end

  private

  def call_and_raise
    yield
  rescue Faraday::ParsingError => e
    raise InvalidResponseError, e.message
  rescue Faraday::ConnectionFailed => e
    raise ConnectionError, e.message
  end

  class ConnectionBuilder
    def build(
      api_root: ENV['HACKNEY_API_ROOT'],
      api_cert: ENV['PROXY_API_CERT'],
      api_key: ENV['PROXY_API_KEY']
    )
      raise InvalidApiRootError, 'API root was nil or empty' if api_root.blank?

      build_connection(
        root: api_root,
        ssl: ssl_options(
          cert: api_cert,
          key: api_key,
        )
      )
    end

    private

    def build_connection(root:, ssl:)
      Faraday.new root, ssl: ssl do |conn|
        conn.adapter Faraday.default_adapter
        conn.response :json
      end
    end

    def ssl_options(cert:, key:)
      return {} if cert.nil?
      raise MissingPrivateKeyError if key.nil?
      {
        client_cert: OpenSSL::X509::Certificate.new(cert),
        client_key:  OpenSSL::PKey::RSA.new(key),
      }
    end
  end
end
