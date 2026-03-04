module TorqueAPI
  class PreAdviceResource < Resource
    def create(payload)
      post_request("preAdvice", body: payload)
    end
  end
end
