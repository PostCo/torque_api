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
  let(:endpoint_url) { "#{TorqueAPI::Client::TEST_BASE_URL}returnRma/100" }

  describe "#list" do
    context "when items are returned" do
      let(:response_body) do
        {
          "ApiMessage" => "Returns Returned",
          "ApiNumber" => "RTS001",
          "returnResponse" => [
            {
              "orderid" => "RMA12345",
              "returns" => [
                {
                  "condition" => "GOOD",
                  "customer" => "Persons Name",
                  "sku" => "5053256503004",
                  "sampling_type" => "GOOD",
                  "qty_returned" => "1",
                  "reason_code" => "6",
                  "reason_notes" => "Style doesn't suit",
                  "return_date" => "23-MAR-2021"
                }
              ]
            },
            {
              "orderid" => "RMA12346",
              "returns" => []
            }
          ]
        }
      end

      before do
        stub_request(:get, endpoint_url)
          .to_return(
            status: 200,
            body: response_body.to_json,
            headers: {"Content-Type" => "application/json"}
          )
      end

      it "returns a Base object with the full response" do
        result = client.return_rma.list
        expect(result).to be_a(TorqueAPI::Objects::ReturnRmaResponse)
        expect(result.api_message).to eq("Returns Returned")
        expect(result.api_number).to eq("RTS001")
      end

      it "converts nested response keys to snake_case" do
        result = client.return_rma.list
        first_order = result.return_response.first

        expect(first_order.orderid).to eq("RMA12345")
        expect(first_order.returns.first.sku).to eq("5053256503004")
        expect(first_order.returns.first.sampling_type).to eq("GOOD")
        expect(first_order.returns.first.reason_code).to eq("6")
      end

      it "preserves original response via .raw" do
        result = client.return_rma.list
        expect(result.raw).to eq(response_body)
        expect(result.raw).to be_frozen
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

    context "when returnResponse is empty" do
      before do
        stub_request(:get, endpoint_url)
          .to_return(
            status: 200,
            body: {"ApiMessage" => "Returns Returned", "ApiNumber" => "RTS001", "returnResponse" => []}.to_json,
            headers: {"Content-Type" => "application/json"}
          )
      end

      it "returns a Base object with empty returnResponse" do
        result = client.return_rma.list
        expect(result).to be_a(TorqueAPI::Objects::ReturnRmaResponse)
        expect(result.return_response).to eq([])
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
