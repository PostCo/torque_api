RSpec.describe TorqueAPI::Client do
  let(:api_key) { "test_api_key_123" }
  let(:client_defaults) do
    {
      "CLIENT_ID" => "AM",
      "CLIENT_GROUP" => "AMVIS",
      "SITE_ID" => "WO6",
      "CONFIG_ID" => "P1",
      "OWNER_ID" => "TORQUE",
      "PALLET_CONFIG" => "MD"
    }
  end

  subject(:client) do
    described_class.new(
      api_key: api_key,
      client_defaults: client_defaults,
      sandbox: sandbox
    )
  end

  describe "#connection" do
    context "when sandbox is false" do
      let(:sandbox) { false }

      it "uses the live base URL" do
        expect(client.connection.url_prefix.to_s).to eq(TorqueAPI::Client::LIVE_BASE_URL)
      end
    end

    context "when sandbox is true" do
      let(:sandbox) { true }

      it "uses the test base URL" do
        expect(client.connection.url_prefix.to_s).to eq(TorqueAPI::Client::TEST_BASE_URL)
      end
    end

    context "headers" do
      let(:sandbox) { false }

      it "sets the Authorization header with Basic auth" do
        expect(client.connection.headers["Authorization"]).to eq("Basic #{api_key}")
      end

      it "sets the Accept header" do
        expect(client.connection.headers["Accept"]).to eq("application/json")
      end

      it "includes all client default headers" do
        client_defaults.each do |key, value|
          expect(client.connection.headers[key]).to eq(value)
        end
      end
    end

    context "memoization" do
      let(:sandbox) { false }

      it "returns the same connection instance" do
        expect(client.connection).to be(client.connection)
      end
    end
  end

  describe "#pre_advice" do
    let(:sandbox) { false }

    it "returns a PreAdviceResource" do
      expect(client.pre_advice).to be_a(TorqueAPI::PreAdviceResource)
    end

    it "memoizes the resource" do
      expect(client.pre_advice).to be(client.pre_advice)
    end
  end

  describe "#return_rma" do
    let(:sandbox) { false }

    it "returns a ReturnRmaResource" do
      expect(client.return_rma).to be_a(TorqueAPI::ReturnRmaResource)
    end

    it "memoizes the resource" do
      expect(client.return_rma).to be(client.return_rma)
    end
  end

  describe "default adapter" do
    let(:sandbox) { false }

    it "uses Faraday default adapter when none specified" do
      client = described_class.new(api_key: api_key)
      expect(client.adapter).to eq(Faraday.default_adapter)
    end

    it "accepts a custom adapter" do
      client = described_class.new(api_key: api_key, adapter: :test)
      expect(client.adapter).to eq(:test)
    end
  end
end
