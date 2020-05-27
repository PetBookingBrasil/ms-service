require "rails_helper"

describe V1::BusinessServicePrices, type: :request do
  include Rack::Test::Methods
  include V1::Helpers::AuthenticatorHelpers

  let(:jwt_helper) { JwtHelper.new("petbooking") }

  before do
    header "Accept", "application/vnd.petbooking-v1+json"
    header "X-Application", "petbooking"
    header "Jwt", jwt_helper.encode("abc123")
  end

  describe "GET /" do
    context "when valid" do
      let!(:data) { create_list(:business_service_price, 3) }

      before { get('/api/business_service_prices') }

      it "returns 200" do
        expect(last_response.status).to eq(200)
      end

      it "returns 3 business_service_prices" do
        expect(JSON.parse(last_response.body)['data'].length).to eq(3)
      end
    end
  end

  describe '#update' do
    context 'when is valid' do
      let(:business_service_price) { create(:business_service_price) }

      context 'updates business service prices' do
        let(:params) do
          { id: business_service_price.id, price: 100 }
        end

        before do
          put("/api/business_service_prices", params)
        end

        it { expect(business_service_price.reload.price).to eq(100.00) }
        it { expect(last_response.status).to eq(200) }
      end

      context 'when invalid' do
        before do
          put("/api/business_service_prices", id: business_service_price.id)
        end

        it { expect(last_response.status).to eq(500) }
      end
    end
  end

  context 'when search' do
    let(:service_one) { create(:service, application: 'bolinha') }
    let(:service_two) { create(:service, application: 'Petbooking') }

    let(:business_service_one) { create(:business_service, service: service_one) }
    let(:business_service_two) { create(:business_service, service: service_two) }

    let!(:business_service_price) { create_list(:business_service_price, 5, business_service: business_service_one) }
    let!(:business_service_price_other) { create_list(:business_service_price, 8, business_service: business_service_two) }

    before do
      BusinessServicePrice.reindex

      get('/api/business_service_prices/search', { where: { application: 'Petbooking' } })
    end

    it 'returns 200' do
      expect(last_response.status).to eq(200)
    end
    it 'returns Service list' do
      expect( JSON.parse(last_response.body)['data']).to have(8).items
    end
  end
end
