require_relative "lib/torque_api/version"

Gem::Specification.new do |spec|
  spec.name = "torque_api"
  spec.version = TorqueAPI::VERSION
  spec.authors = ["PostCo"]
  spec.email = ["dev@postco.co"]

  spec.summary = "Ruby client for the Torque WMS API"
  spec.description = "A Ruby wrapper for the Torque Warehouse Management System API, supporting Pre Advice creation and Return RMA polling."
  spec.homepage = "https://github.com/PostCo/torque_api"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  spec.files = Dir["lib/**/*", "CHANGELOG.md", "README.md", "LICENSE.txt"]
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", "~> 2.0"
  spec.add_dependency "faraday-net_http", ">= 2.0"
  spec.add_dependency "activesupport", ">= 7.0"

  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 3.0"
  spec.add_development_dependency "standard"
end
