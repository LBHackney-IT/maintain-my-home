class JsonApi
  class InvalidApiRootError < StandardError; end

  def initialize(api_root: ENV['HACKNEY_API_ROOT'])
    raise InvalidApiRootError, 'api_root was nil or empty' if api_root.blank?

    @connection = Faraday.new api_root do |conn|
      conn.adapter Faraday.default_adapter
      conn.response :json, content_type: /\bjson$/
    end
  end

  def get(path)
    @connection.get(path).body
  end
end
