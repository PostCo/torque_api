require "faraday"

module TorqueAPI
  class Client
    LIVE_BASE_URL = "https://wms-api.torque.eu/torqueapi/api/v1/"
    TEST_BASE_URL = "https://wms-api.torque.eu/torqueapitest/api/v1/"

    attr_reader :api_key, :client_defaults, :adapter

    def initialize(api_key:, client_defaults: {}, sandbox: false, adapter: Faraday.default_adapter)
      @api_key = api_key
      @client_defaults = client_defaults
      @sandbox = sandbox
      @adapter = adapter
    end

    def pre_advice
      @pre_advice ||= PreAdviceResource.new(self)
    end

    def return_rma
      @return_rma ||= ReturnRmaResource.new(self)
    end

    def connection
      @connection ||= Faraday.new do |conn|
        conn.url_prefix = sandbox? ? TEST_BASE_URL : LIVE_BASE_URL
        conn.headers["Authorization"] = "Basic #{api_key}"
        conn.headers["Accept"] = "application/json"
        client_defaults.each { |key, value| conn.headers[key.to_s] = value.to_s }
        conn.request :json
        conn.response :json, content_type: "application/json"
        conn.adapter adapter
      end
    end

    private

    def sandbox?
      @sandbox
    end
  end
end
