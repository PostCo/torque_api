# TorqueAPI

Ruby client for the [Torque WMS](https://torque.eu/) (Warehouse Management System) API.

## Installation

Add to your Gemfile:

```ruby
gem "torque_api", git: "https://github.com/PostCo/torque_api", branch: "main"
```

## Usage

### Initialize a client

```ruby
client = TorqueAPI::Client.new(
  api_key: "your_api_key",
  client_defaults: {
    "CLIENT_ID" => "AM",
    "CLIENT_GROUP" => "AMVIS",
    "SITE_ID" => "WO6",
    "CONFIG_ID" => "P1",
    "OWNER_ID" => "TORQUE",
    "PALLET_CONFIG" => "MD"
  },
  sandbox: true  # Use test environment
)
```

### Create a Pre Advice

```ruby
payload = [
  {
    "Record_Type" => "PAH",
    "Pre_Advice_Id" => "12345",
    "Status" => "Released",
    "PreAdviceLines" => [
      {
        "Record_Type" => "PAL",
        "Pre_Advice_Id" => "12345",
        "Sku_Id" => "SKU-001",
        "Qty_Due" => 1,
        "Line_Id" => 1
      }
    ]
  }
]

response = client.pre_advice.create(payload)
```

### Poll Return RMA items

```ruby
items = client.return_rma.list
# Returns an array of TorqueAPI::Objects::ReturnRma

items.each do |item|
  puts item.orderid          # snake_case accessors
  puts item.sku_id
  puts item.sampling_type
  puts item.raw              # Access original (frozen) response data
end
```

### Error handling

```ruby
begin
  client.pre_advice.create(payload)
rescue TorqueAPI::AuthenticationError => e
  # 401/403 responses
  puts e.message
  puts e.status_code
  puts e.response  # Full Faraday response
rescue TorqueAPI::ValidationError => e
  # 400 responses
rescue TorqueAPI::NotFoundError => e
  # 404 responses
rescue TorqueAPI::ServerError => e
  # 500-599 responses
rescue TorqueAPI::APIError => e
  # All other error responses
end
```

### Sandbox mode

Toggle between test and live Torque environments:

```ruby
# Test: https://wms-api.torque.eu/torqueapitest/api/v1
client = TorqueAPI::Client.new(api_key: key, sandbox: true)

# Live: https://wms-api.torque.eu/torqueapi/api/v1
client = TorqueAPI::Client.new(api_key: key, sandbox: false)
```

## Development

```bash
bundle install
bundle exec rspec        # Run tests
bundle exec standardrb   # Run linter
```

## License

MIT License. See [LICENSE.txt](LICENSE.txt).
