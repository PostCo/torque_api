require_relative "torque_api/version"

module TorqueAPI
  autoload :Client, "torque_api/client"
  autoload :Base, "torque_api/object"
  autoload :Resource, "torque_api/resource"
  autoload :Error, "torque_api/errors"
  autoload :APIError, "torque_api/errors"
  autoload :AuthenticationError, "torque_api/errors"
  autoload :ValidationError, "torque_api/errors"
  autoload :NotFoundError, "torque_api/errors"
  autoload :RateLimitError, "torque_api/errors"
  autoload :ServerError, "torque_api/errors"
  autoload :PreAdviceResource, "torque_api/resources/pre_advice_resource"
  autoload :ReturnRmaResource, "torque_api/resources/return_rma_resource"

  module Objects
    autoload :ReturnRma, "torque_api/objects/return_rma"
  end
end
