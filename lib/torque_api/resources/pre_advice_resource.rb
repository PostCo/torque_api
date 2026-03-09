module TorqueAPI
  class PreAdviceResource < Resource
    def create(payload)
      data = post_request("preAdvice", body: payload)
      Objects::PreAdviceResponse.new(data)
    end
  end
end
