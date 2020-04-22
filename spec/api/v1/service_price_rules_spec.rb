require "spec_helper"

RSpec.describe ::V1::ServicePriceRules do
  include Rack::Test::Methods
  include V1::Helpers::AuthenticatorHelpers

  ENV["PETBOOKING_SECRET"] = "abc123"
  let(:jwt_helper) { JwtHelper.new("petbooking") }

  def app
    ::V1::ServicePriceRules
  end

  before do
    header "Accept", "application/vnd.petbooking-v1+json"
    header "X-Application", "petbooking"
    header "Jwt", jwt_helper.encode("abc123")
  end

  describe "GET /" do
    context "when valid" do
      let!(:data) { create_list(:service_price_rule, 3)}
      let(:response) { get('/api/service_price_rules') }
    
      it "returns 200" do
        expect(response.status).to eq(200)  
      end

      it "returns 3 service_price_rules" do
        expect(JSON.parse(response.body)['data'].length).to eq(3)  
      end
    end
  end

end