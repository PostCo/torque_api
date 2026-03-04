module TorqueAPI
  class Error < StandardError
    attr_reader :response, :status_code

    def initialize(message = nil, response: nil, status_code: nil)
      super(message)
      @response = response
      @status_code = status_code
    end
  end

  class APIError < Error; end
  class AuthenticationError < Error; end
  class ValidationError < Error; end
  class NotFoundError < Error; end
  class RateLimitError < Error; end
  class ServerError < Error; end
end
