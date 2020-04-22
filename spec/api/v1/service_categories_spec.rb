require "spec_helper"

RSpec.describe ::V1::ServiceCategories do
  include Rack::Test::Methods
  include V1::Helpers::AuthenticatorHelpers

  ENV["PETBOOKING_SECRET"] = "abc123"
  let(:jwt_helper) { JwtHelper.new("petbooking") }

  def app
    ::V1::ServiceCategories
  end

  before do
    header "Accept", "application/vnd.petbooking-v1+json"
    header "X-Application", "petbooking"
    header "Jwt", jwt_helper.encode("abc123")
  end

  describe "GET /" do
    context "when valid" do
      let!(:data) { create_list(:service_category, 3)}
      let(:response) { get('/api/service_categories') }
    
      it "returns 200" do
        expect(response.status).to eq(200)  
      end

      it "returns 3 service_categories" do
        expect(JSON.parse(response.body)['data'].length).to eq(3)  
      end
    end
  end

  context "invalid requests" do 
    describe "GET /" do
      context "when application is invalid" do
        before do
          header "Accept", "application/vnd.petbooking-v1+json"
          header "X-Application", "invalid_app"
          header "Jwt", jwt_helper.encode("abc123")
        end

        let(:response) { get('/api/service_categories') }
      
        it "returns 401" do
          expect(response.status).to eq(401)  
        end
      end

      context "when JWT signature is invalid" do
        before do
          header "Accept", "application/vnd.petbooking-v1+json"
          header "X-Application", "petbooking"
          header "Jwt", JWT.encode("abc123", "invalid_app", 'HS256')
        end

        let(:response) { get('/api/service_categories') }
      
        it "returns 422" do
          expect(response.status).to eq(422)  
        end

        it "returns JWT error message" do
          expect(JSON.parse(response.body)['error']).to include('Signature verification raised')  
        end
      end
    end
  end
end