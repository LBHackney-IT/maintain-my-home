class JsonApi
  class Error < StandardError; end

  class InvalidApiRootError < Error; end
  class MissingPrivateKeyError < Error; end

  class ApiError < Error; end
  class InvalidResponseError < ApiError; end
  class ConnectionError < ApiError; end
  class TimeoutError < ApiError; end
  class StatusBadRequestError < ApiError; end
  class StatusNotFoundError < ApiError; end
  class StatusServerError < ApiError; end
  class StatusUnexpectedError < ApiError; end

  def initialize(api_config = {}, logger = Rails.logger)
    @connection = ConnectionBuilder.new.build(logger, api_config)
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
    yield.tap { |response| raise_for_http_status(response) }
  rescue Faraday::ParsingError => e
    raise InvalidResponseError, e.message
  rescue Faraday::ConnectionFailed => e
    raise ConnectionError, e.message
  rescue Rack::Timeout::RequestTimeoutException => e
    raise TimeoutError, e.message
  end

  def raise_for_http_status(response)
    return unless error_klass(response.status)
    raise error_klass(response.status), error_message(response)
  end

  def error_klass(status)
    case status
    when 404
      StatusNotFoundError
    when 400, 422
      StatusBadRequestError
    when 500
      StatusServerError
    else
      StatusUnexpectedError unless status == 200
    end
  end

  def error_message(response)
    case response.body
    when Array
      response.body
              .map { |error| error.fetch('developerMessage', '') }
              .join(', ')
    when Hash
      response.body.fetch('errors', response.body)['developerMessage']
    end
  end

  class ConnectionBuilder
    def build(
      logger,
      api_root: ENV['HACKNEY_API_URL']
    )
      raise InvalidApiRootError, 'API root was nil or empty' if api_root.blank?

      build_connection(
        root: api_root,
        logger: logger,
      )
    end

    private

    def build_connection(root:, logger:)
      Faraday.new root do |conn|
        conn.adapter Faraday.default_adapter
        conn.headers["x-api-key"] = ENV['HACKNEY_API_TOKEN']
        conn.response :json
        conn.response :logger, logger, headers: true, bodies: true
      end
    end
  end
end
