module TorqueAPI
  class ReturnRmaResource < Resource
    def list
      data = get_request("returnRma")
      Array(data).map { |item| Objects::ReturnRma.new(item) }
    end
  end
end
