Rack::Timeout.service_timeout = ENV.fetch('RACK_SERVICE_TIMEOUT', 15).to_i
