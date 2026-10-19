require "spec_helper"

module MCollective
  describe SSL do
    describe ".base64_encode" do
      it "should encode without line breaks" do
        encoded = SSL.base64_encode("x" * 100)

        expect(encoded).not_to include("\n")
        expect(Base64.decode64(encoded)).to eq("x" * 100)
      end
    end

    describe ".base64_decode" do
      it "should decode base64 with line breaks" do
        expect(SSL.base64_decode(Base64.encode64("x" * 100))).to eq("x" * 100)
      end

      it "should decode what base64_encode produces" do
        expect(SSL.base64_decode(SSL.base64_encode("x" * 100))).to eq("x" * 100)
      end

      it "should decode base64 without line breaks" do
        expect(SSL.base64_decode("aGVsbG8=")).to eq("hello")
      end

      it "should refuse a character outside the base64 set" do
        expect { SSL.base64_decode("aGVs*bG8=") }.to raise_error(ArgumentError, "invalid base64")
      end

      it "should refuse a character outside the base64 set on a later line" do
        expect { SSL.base64_decode("aGVs\nbG8=*\n") }.to raise_error(ArgumentError, "invalid base64")
      end

      it "should refuse an empty string" do
        expect { SSL.base64_decode("") }.to raise_error(ArgumentError, "invalid base64")
      end
    end
  end
end
