module TorqueAPI
  class Resource
    attr_reader :client

    def initialize(client)
      @client = client
    end

    private

    def get_request(url, params: {}, headers: {})
      handle_response client.connection.get(url, params, headers)
    rescue Faraday::Error => e
      raise APIError, "Network error: #{e.message}"
    end

    def post_request(url, body:, headers: {})
      handle_response client.connection.post(url, body, headers)
    rescue Faraday::Error => e
      raise APIError, "Network error: #{e.message}"
    end

    def handle_response(response)
      return response.body if response.status.between?(200, 299)

      error_class, prefix = error_mapping(response.status)
      message = "#{prefix} (HTTP #{response.status}): #{extract_error_message(response.body)}"
      raise error_class.new(message, response: response, status_code: response.status)
    end

    def error_mapping(status)
      case status
      when 400 then [ValidationError, "Bad request"]
      when 401, 403 then [AuthenticationError, "Authentication failed"]
      when 404 then [NotFoundError, "Resource not found"]
      when 429 then [RateLimitError, "Rate limited"]
      when 500..599 then [ServerError, "Server error"]
      else [APIError, "API error"]
      end
    end

    def extract_error_message(body)
      case body
      when Hash then body["message"] || body["error"] || body.to_s
      when String then body
      else body.to_s
      end
    end
  end
end
