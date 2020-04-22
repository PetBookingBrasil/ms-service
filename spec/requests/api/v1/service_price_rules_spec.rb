require "rails_helper"

describe V1::ServicePriceRules, type: :request do
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
      let!(:data) { create_list(:service_price_rule, 3) }
      let(:response) { get('/api/service_price_rules') }

      it "returns 200" do
        expect(response.status).to eq(200)
      end

      it "returns 3 service_price_rules" do
        expect(JSON.parse(response.body)['data'].length).to eq(3)
      end
    end
  end

  describe '#update' do
    context 'when is valid' do
      let!(:service_price_rule) do
        create(:service_price_rule,
               service_price_variations: [
                 create(:service_price_variation, :size, variations: ['p', 'g']),
                 create(:service_price_variation, :coat, variations: ['curto', 'longo'])
               ]
        )
      end

      before do
        ['p curto', 'p longo', 'g curto', 'g longo'].each do |variation|
          service_price_combination = create(:service_price_combination,
                                             service_price_rule: service_price_rule,
                                             name: variation)

          create(:business_service_price,
                 service_price_combination: service_price_combination,
                 price: 0)
        end
      end

      context 'with variations changes' do
        let(:attributes) do
          attributes_for(:service_price_rule,
                         service_price_variations_attributes: [
                           attributes_for(:service_price_variation,
                                          :size,
                                          id: service_price_rule.service_price_variations.first.id,
                                          variations: ['p', 'gg']
                           ),
                           attributes_for(:service_price_variation,
                                          :coat,
                                          id: service_price_rule.service_price_variations.last.id,
                                          variations: ['curto', 'longo'])
                         ]
          )
        end

        let(:params) do
          { id: service_price_rule.id, service_price_rule: attributes }
        end

        let!(:response) { put("/api/service_price_rules", params) }
        let(:combinations) { service_price_rule.service_price_combinations.pluck(:slug) }


        it { expect(service_price_rule.service_price_variations.reload.first.variations).to eq(['p', 'gg']) }
        it { expect(service_price_rule.service_price_variations.reload.last.variations).to eq(['curto', 'longo']) }

        it { expect(combinations).to include('gg-longo') }
        it { expect(combinations).to include('gg-curto') }

        it { expect(combinations).to_not include('g-longo') }
        it { expect(combinations).to_not include('g-curto') }

        it { expect(last_response.status).to eq(200) }
      end

      context 'with variations deleted' do
        let(:attributes) do
          attributes_for(:service_price_rule,
                         service_price_variations_attributes: [
                           attributes_for(:service_price_variation,
                                          :size,
                                          id: service_price_rule.service_price_variations.first.id,
                                          variations: ['p', 'gg']
                           ),
                           attributes_for(:service_price_variation,
                                          :coat,
                                          _destroy: 1,
                                          id: service_price_rule.service_price_variations.last.id,
                                          variations: ['curto', 'longo'])
                         ]
          )
        end

        let(:params) do
          { id: service_price_rule.id, service_price_rule: attributes }
        end

        before { put("/api/service_price_rules", params) }

        let(:combinations) { service_price_rule.service_price_combinations.pluck(:slug) }

        it { expect(service_price_rule.service_price_variations.count).to eq 1 }
        it { expect(combinations).to_not include('p-curto') }
        it { expect(combinations).to_not include('p-longo') }
        it { expect(combinations).to_not include('g-curto') }
        it { expect(combinations).to_not include('g-longo') }
        it { expect(last_response.status).to eq(200) }
      end
    end

    context 'when invalid' do
      let!(:response) { put("/api/service_price_rules", {}) }

      it { expect(last_response.status).to eq(500) }
    end
  end

  describe '#create' do
    context 'when valid' do
      let(:service_price_rule_one) do
        attributes_for(:service_price_rule,
                       service_price_variations_attributes: [
                         attributes_for(:service_price_variation, :size),
                         attributes_for(:service_price_variation, :coat)
                       ]
        )
      end

      let(:service_price_rule_two) do
        attributes_for(:service_price_rule,
                       service_price_variations_attributes: [
                         attributes_for(:service_price_variation, :coat),
                         attributes_for(:service_price_variation, :breed)
                       ]
        )
      end

      let(:params) do
        { service_price_rules: [service_price_rule_one, service_price_rule_two] }
      end

      let(:response) { post("/api/service_price_rules", params) }

      it { expect { response }.to change(ServicePriceRule, :count).by(2) }
      it { expect { response }.to change(ServicePriceVariation, :count).by(4) }
      it { expect { response }.to change(ServicePriceCombination, :count).by(24) }
      it { expect { response }.to change(BusinessServicePrice, :count).by(24) }

      it { expect(response.status).to eq(201) }
    end

    context 'when invalid' do
      let!(:response) { post("/api/service_price_rules", {}) }

      it { expect(last_response.status).to eq(500) }
    end
  end
end
