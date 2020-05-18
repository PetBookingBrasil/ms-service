require 'spec_helper'

RSpec.describe ::V1::ServiceCategories, type: :request do
  include Rack::Test::Methods

  ENV["PETBOOKING_SECRET"] = 'abc123'

  let(:jwt_helper) { JwtHelper.new("petbooking") }
  let(:root_service_category) { create(:service_category) }
  let(:body) { JSON.parse(response.body) }

  before do
    header "Accept", "application/vnd.petbooking-v1+json"
    header "X-Application", "petbooking"
    header "Jwt", jwt_helper.encode("abc123")
  end

  describe '#index' do
    before do
      create_list(:service_category, 10, parent_id: root_service_category.id)
      ServiceCategory.reindex
    end

    let!(:response) { get("/api/service_categories") }

    context 'when valid' do
      it 'returns 200' do
        expect(response.status).to eq(200)
      end

      it 'returns correct hash structure' do
        expect(body.keys).to eql(["data"])
        expect(body["data"].first.keys).to eql(
                                             ['id', 'name', 'slug', 'cover_image', 'cover_image_cache',
                                              'icon', 'icon_cache', 'html_class_name', 'position', 'aasm_state',
                                              'system_code', 'business_id', 'children']
                                           )
      end

      it 'returns Service Categories list' do
        expect(body["data"]).to have(11).items
      end
    end
  end

  describe '#search' do
    before do
      create_list(:service_category, 5, parent_id: root_service_category.id, business_id: 1)
      create_list(:service_category, 10, parent_id: root_service_category.id, business_id: 2)
      create_list(:service_category, 10, parent_id: root_service_category.id, business_id: 3)
      ServiceCategory.reindex
    end

    context 'when one business_id is passed' do
      let!(:response) { get("/api/service_categories/search", { where: { business_id: 1 } }) }

      it 'returns 200' do
        expect(response.status).to eq(200)
      end

      it 'returns Service Categories by business_id' do
        expect(body['data'].length).to eq(6)
      end
    end

    context 'when two business_ids are passed' do
      let!(:response) { get("/api/service_categories/search", { where: { business_id: [1, 3] } }) }

      it 'returns 200' do
        expect(response.status).to eq(200)
      end

      it 'returns Service Categories by business_ids' do
        expect(body['data'].length).to eq(16)
      end
    end

    context 'when invalid' do
      let!(:response) { get("/api/service_categories/search", { business_id: nil }) }

      it 'returns 500' do
        expect(response.status).to eq(500)
      end

      it 'returns 0 services' do
        expect(body.keys).to eql(['error'])
      end
    end
  end

  describe '#create' do
    let(:valid_params) { attributes_for(:service_category) }

    context 'when valid' do
      let!(:response) { post("/api/service_categories", valid_params) }

      it 'returns 201' do
        expect(response.status).to eq(201)
      end

      it 'returns Service Category data' do
        expect(body['data'].symbolize_keys[:name]).to eql(valid_params[:name])
      end
    end

    context 'when invalid' do
      context 'when fail in create context' do
        let!(:response) { post("/api/service_categories") }

        it 'returns 500' do
          expect(response.status).to eq(500)
        end
      end
    end
  end

  describe '#update' do
    let!(:service_category) { create(:service_category, :with_parent) }
    context 'with valid paramters' do
      let!(:response) { put("/api/service_categories?id=#{service_category.id}", { name: 'new-name' }) }

      it 'updates a Service Category' do
        service_category.reload

        expect(service_category.name).to eql('new-name')
      end
    end

    context 'with invalid paramters' do
      let!(:response) { put("/api/service_categories?id=#{service_category.id}", { invalid: true }) }

      it 'returns http error' do
        expect(response.status).to eql(422)
      end

      it 'returns error messages' do
        expect(body.keys).to eql(['error'])
      end
    end
  end

  describe '#delete' do
    let!(:service_category) { create(:service_category) }
    before do
      create_list(:service_category, 10, parent_id: service_category.id)
      ServiceCategory.reindex
    end

    context 'delete with the childrens Service Categories' do
      let(:response) { delete("/api/service_categories?id=#{service_category.id}") }

      it 'returns 200' do
        expect(response.status).to eq(200)
      end

      it 'returns Service Category' do
        expect(body['data']['id']).to eq(service_category.id)
      end
    end

    context 'when invalid' do
      context 'when Service Category does not exists' do
        let(:response) { delete("/api/service_categories") }

        it 'returns 500' do
          expect(response.status).to eq(500)
        end

        it 'returns error message' do
          expect(body).to eql({ 'error' => 'Invalid response' })
        end
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

  describe '#search_by_scope' do
    context 'when search by scope' do
      let!(:service_category) { create(:service_category, business_id: 10) }

      let(:response) { JSON.parse(last_response.body)['data'] }

      before do
        ServiceCategory.reindex
        get("/api/service_categories/search_by_scope", { scope_name: 'by_business_and_name',
                                               options: { business: [10], name: service_category.name.downcase } })
      end

      it { expect(last_response.status).to eq(200) }
      it { expect(response.last['name']).to eq(service_category.name) }
      it { expect(response.last['business_id']).to eq(10) }
      it { expect(response.count).to eq(1) }
    end
  end

  describe '#update_all' do
    context 'when update service categories multiples' do
      let!(:service_category_one) do
        create(:service_category, aasm_state: 1, position: 4)
      end
      let!(:service_category_two) do
        create(:service_category, aasm_state: 0, position: 5)
      end

      let(:attributes_one) do
        { aasm_state: 'enabled', position: 2, id: service_category_one.id }
      end

      let(:attributes_two) do
        { aasm_state: 'enabled', position: 3, id: service_category_two.id }
      end

      let(:data) do
        [
          attributes_one,
          attributes_two
        ]
      end

      let(:response) { JSON.parse(last_response.body)['data'] }

      before do
        ServiceCategory.reindex
        put("/api/service_categories/update_all", { data: data })
      end

      it { expect(service_category_one.reload.aasm_state).to eq 'enabled' }
      it { expect(service_category_one.reload.position).to eq 2 }
      it { expect(service_category_two.reload.aasm_state).to eq 'enabled' }
      it { expect(service_category_two.reload.position).to eq 3 }
      it { expect(response.count).to eq 2 }
    end
  end
end
