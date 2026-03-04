RSpec.describe TorqueAPI::ReturnRmaResource do
  let(:api_key) { "test_api_key" }
  let(:client_defaults) do
    {
      "CLIENT_ID" => "AM",
      "CLIENT_GROUP" => "AMVIS",
      "SITE_ID" => "WO6"
    }
  end
  let(:client) do
    TorqueAPI::Client.new(
      api_key: api_key,
      client_defaults: client_defaults,
      sandbox: true
    )
  end
  let(:endpoint_url) { "#{TorqueAPI::Client::TEST_BASE_URL}returnRma" }

  describe "#list" do
    context "when items are returned" do
      let(:response_body) do
        [
          {
            "orderid" => "12345",
            "Sku_Id" => "SKU-001",
            "Sampling_Type" => "GOOD",
            "Condition" => "A",
            "Reason_Code" => "RC1",
            "Reason_Notes" => "Good condition",
            "Qty_Returned" => 1,
            "Return_Date" => "2025-03-01"
          },
          {
            "orderid" => "12345",
            "Sku_Id" => "SKU-002",
            "Sampling_Type" => "BAD",
            "Condition" => "D",
            "Reason_Code" => "RC2",
            "Reason_Notes" => "Damaged",
            "Qty_Returned" => 1,
            "Return_Date" => "2025-03-01"
          }
        ]
      end

      before do
        stub_request(:get, endpoint_url)
          .to_return(
            status: 200,
            body: response_body.to_json,
            headers: {"Content-Type" => "application/json"}
          )
      end

      it "returns an array of ReturnRma objects" do
        items = client.return_rma.list
        expect(items).to all(be_a(TorqueAPI::Objects::ReturnRma))
        expect(items.length).to eq(2)
      end

      it "converts response keys to snake_case" do
        items = client.return_rma.list
        item = items.first

        expect(item.orderid).to eq("12345")
        expect(item.sku_id).to eq("SKU-001")
        expect(item.sampling_type).to eq("GOOD")
        expect(item.condition).to eq("A")
        expect(item.reason_code).to eq("RC1")
        expect(item.reason_notes).to eq("Good condition")
        expect(item.qty_returned).to eq(1)
        expect(item.return_date).to eq("2025-03-01")
      end

      it "preserves original response via .raw" do
        items = client.return_rma.list
        raw = items.first.raw

        expect(raw["Sku_Id"]).to eq("SKU-001")
        expect(raw["Sampling_Type"]).to eq("GOOD")
        expect(raw).to be_frozen
      end

      it "sends client default headers" do
        client.return_rma.list

        expect(WebMock).to have_requested(:get, endpoint_url)
          .with(headers: {
            "Authorization" => "Basic #{api_key}",
            "Client-Id" => "AM",
            "Client-Group" => "AMVIS",
            "Site-Id" => "WO6"
          })
      end
    end

    context "when response is empty" do
      before do
        stub_request(:get, endpoint_url)
          .to_return(
            status: 200,
            body: [].to_json,
            headers: {"Content-Type" => "application/json"}
          )
      end

      it "returns an empty array" do
        expect(client.return_rma.list).to eq([])
      end
    end

    context "when response is nil" do
      before do
        stub_request(:get, endpoint_url)
          .to_return(
            status: 200,
            body: "null",
            headers: {"Content-Type" => "application/json"}
          )
      end

      it "returns an empty array" do
        expect(client.return_rma.list).to eq([])
      end
    end

    context "when authentication fails" do
      before do
        stub_request(:get, endpoint_url)
          .to_return(
            status: 401,
            body: {"message" => "Unauthorized"}.to_json,
            headers: {"Content-Type" => "application/json"}
          )
      end

      it "raises AuthenticationError" do
        expect { client.return_rma.list }
          .to raise_error(TorqueAPI::AuthenticationError) do |error|
            expect(error.status_code).to eq(401)
            expect(error.response).not_to be_nil
          end
      end
    end

    context "when rate limited (429)" do
      before do
        stub_request(:get, endpoint_url)
          .to_return(
            status: 429,
            body: {"message" => "Too many requests"}.to_json,
            headers: {"Content-Type" => "application/json"}
          )
      end

      it "raises RateLimitError" do
        expect { client.return_rma.list }
          .to raise_error(TorqueAPI::RateLimitError) do |error|
            expect(error.status_code).to eq(429)
          end
      end
    end
  end
end
