RSpec.describe TorqueAPI::Base do
  describe "key conversion" do
    it "converts PascalCase_Underscore keys to snake_case" do
      obj = described_class.new("Pre_Advice_Id" => "123", "Record_Type" => "PAH")
      expect(obj.pre_advice_id).to eq("123")
      expect(obj.record_type).to eq("PAH")
    end

    it "converts standard PascalCase keys to snake_case" do
      obj = described_class.new("PreAdviceLines" => [])
      expect(obj.pre_advice_lines).to eq([])
    end

    it "converts camelCase keys to snake_case" do
      obj = described_class.new("orderid" => "456", "samplingType" => "GOOD")
      expect(obj.orderid).to eq("456")
      expect(obj.sampling_type).to eq("GOOD")
    end

    it "handles already snake_case keys" do
      obj = described_class.new("sku" => "SKU-001", "qty_returned" => 1)
      expect(obj.sku).to eq("SKU-001")
      expect(obj.qty_returned).to eq(1)
    end
  end

  describe "nested conversion" do
    it "recursively converts nested hashes" do
      obj = described_class.new(
        "Pre_Advice_Id" => "123",
        "Address" => {"Address1" => "123 Main St", "Postcode" => "12345"}
      )
      expect(obj.address.address1).to eq("123 Main St")
      expect(obj.address.postcode).to eq("12345")
    end

    it "recursively converts arrays of hashes" do
      obj = described_class.new(
        "PreAdviceLines" => [
          {"Sku_Id" => "SKU-001", "Qty_Due" => 1},
          {"Sku_Id" => "SKU-002", "Qty_Due" => 2}
        ]
      )
      expect(obj.pre_advice_lines.length).to eq(2)
      expect(obj.pre_advice_lines[0].sku_id).to eq("SKU-001")
      expect(obj.pre_advice_lines[1].qty_due).to eq(2)
    end

    it "preserves non-hash, non-array values" do
      obj = described_class.new("Value" => 42, "Flag" => true, "Name" => nil)
      expect(obj.value).to eq(42)
      expect(obj.flag).to eq(true)
      expect(obj.name).to be_nil
    end
  end

  describe "#original_response" do
    it "preserves the raw response data" do
      attrs = {"Pre_Advice_Id" => "123", "Record_Type" => "PAH"}
      obj = described_class.new(attrs)
      expect(obj.original_response).to eq(attrs)
    end

    it "freezes the original response deeply" do
      attrs = {"Nested" => {"Key" => "value"}, "Items" => ["a", "b"]}
      obj = described_class.new(attrs)
      expect(obj.original_response).to be_frozen
      expect(obj.original_response["Nested"]).to be_frozen
      expect(obj.original_response["Items"]).to be_frozen
    end
  end

  describe "#raw" do
    it "is an alias for original_response" do
      obj = described_class.new("Key" => "value")
      expect(obj.raw).to be(obj.original_response)
    end
  end

  describe "#to_hash" do
    it "converts back to a plain hash with snake_case string keys" do
      obj = described_class.new("Pre_Advice_Id" => "123", "Qty_Due" => 1)
      hash = obj.to_hash
      expect(hash).to be_a(Hash)
      expect(hash["pre_advice_id"]).to eq("123")
      expect(hash["qty_due"]).to eq(1)
    end

    it "recursively converts nested objects" do
      obj = described_class.new(
        "Header" => {"Status" => "Released"},
        "Lines" => [{"Sku_Id" => "SKU-001"}]
      )
      hash = obj.to_hash
      expect(hash["header"]).to be_a(Hash)
      expect(hash["header"]["status"]).to eq("Released")
      expect(hash["lines"]).to be_an(Array)
      expect(hash["lines"][0]["sku_id"]).to eq("SKU-001")
    end
  end
end
