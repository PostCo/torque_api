module TorqueAPI
  class ReturnRmaResource < Resource
    def list
      data = get_request("returnRma/100")
      Objects::ReturnRmaResponse.new(data)
    end
  end
end
