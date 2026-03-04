RSpec.describe TorqueAPI::PreAdviceResource do
  let(:api_key) { "test_api_key" }
  let(:client) { TorqueAPI::Client.new(api_key: api_key, sandbox: true) }
  let(:endpoint_url) { "#{TorqueAPI::Client::TEST_BASE_URL}preAdvice" }

  describe "#create" do
    let(:payload) do
      [
        {
          "Record_Type" => "PAH",
          "Pre_Advice_Id" => "12345",
          "Status" => "Released",
          "PreAdviceLines" => [
            {
              "Record_Type" => "PAL",
              "Sku_Id" => "SKU-001",
              "Qty_Due" => 1,
              "Line_Id" => 1
            }
          ]
        }
      ]
    end

    context "when successful" do
      before do
        stub_request(:post, endpoint_url)
          .to_return(
            status: 200,
            body: {"status" => "success"}.to_json,
            headers: {"Content-Type" => "application/json"}
          )
      end

      it "posts the payload to /preAdvice" do
        result = client.pre_advice.create(payload)
        expect(result).to eq({"status" => "success"})
      end

      it "passes the payload through without key transformation" do
        client.pre_advice.create(payload)

        expect(WebMock).to have_requested(:post, endpoint_url)
          .with(body: payload.to_json)
      end
    end

    context "when authentication fails (401)" do
      before do
        stub_request(:post, endpoint_url)
          .to_return(
            status: 401,
            body: {"message" => "Invalid credentials"}.to_json,
            headers: {"Content-Type" => "application/json"}
          )
      end

      it "raises AuthenticationError" do
        expect { client.pre_advice.create(payload) }
          .to raise_error(TorqueAPI::AuthenticationError) do |error|
            expect(error.status_code).to eq(401)
            expect(error.message).to include("Authentication failed")
            expect(error.message).to include("Invalid credentials")
            expect(error.response).not_to be_nil
          end
      end
    end

    context "when forbidden (403)" do
      before do
        stub_request(:post, endpoint_url)
          .to_return(
            status: 403,
            body: {"message" => "Forbidden"}.to_json,
            headers: {"Content-Type" => "application/json"}
          )
      end

      it "raises AuthenticationError" do
        expect { client.pre_advice.create(payload) }
          .to raise_error(TorqueAPI::AuthenticationError) do |error|
            expect(error.status_code).to eq(403)
          end
      end
    end

    context "when bad request (400)" do
      before do
        stub_request(:post, endpoint_url)
          .to_return(
            status: 400,
            body: {"error" => "Missing required field"}.to_json,
            headers: {"Content-Type" => "application/json"}
          )
      end

      it "raises ValidationError" do
        expect { client.pre_advice.create(payload) }
          .to raise_error(TorqueAPI::ValidationError) do |error|
            expect(error.status_code).to eq(400)
            expect(error.message).to include("Missing required field")
          end
      end
    end

    context "when server error (500)" do
      before do
        stub_request(:post, endpoint_url)
          .to_return(
            status: 500,
            body: "Internal Server Error",
            headers: {"Content-Type" => "text/plain"}
          )
      end

      it "raises ServerError" do
        expect { client.pre_advice.create(payload) }
          .to raise_error(TorqueAPI::ServerError) do |error|
            expect(error.status_code).to eq(500)
          end
      end
    end
  end
end
