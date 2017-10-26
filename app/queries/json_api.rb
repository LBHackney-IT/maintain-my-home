class JsonApi
  class Error < StandardError; end
  class InvalidApiRootError < StandardError; end
  class InvalidResponseError < StandardError; end

  def initialize(api_root: ENV['HACKNEY_API_ROOT'])
    raise InvalidApiRootError, 'API root was nil or empty' if api_root.blank?

    @connection = Faraday.new api_root do |conn|
      conn.adapter Faraday.default_adapter
      conn.response :json
    end
  end

  def get(path)
    @connection.get(path).body
  rescue Faraday::ParsingError => e
    raise InvalidResponseError, e.message
  end

  def post(path, params)
    response = @connection.post(path) do |request|
      request.body = params.to_json
      request.headers['Content-Type'] = 'application/json'
    end
    response.body
  rescue Faraday::ParsingError => e
    raise InvalidResponseError, e.message
  end
end
