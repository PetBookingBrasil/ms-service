require 'spec_helper' 

RSpec.describe ::V1::ServiceCategories, type: :request do
  include Rack::Test::Methods
  # include V1::Helpers::AuthenticatorHelpers

  ENV["PETBOOKING_SECRET"] = 'abc123'

  let(:jwt_helper) { JwtHelper.new("petbooking") }
  let(:root_service_category) { create(:service_category) }
  let(:body) { JSON.parse(response.body) }

  def app
    ::V1::ServiceCategories
  end

  before do
    header 'Accept', "application/vnd.petbooking-v1+json"
    header 'X-Device', "web"
    header 'X-Application', "petbooking"
  end

  describe '#index' do
    before do
      create_list(:service_category, 10, parent_id: root_service_category.id)
    end

    let!(:response){ get("/api/service_categories") }

  	context 'when valid' do
      it 'returns 200' do
        expect(response.status).to eq(200)
      end

      it 'returns correct hash structure' do
        expect(body.keys).to eql(["data"])
        expect(body["data"].first.keys).to eql(['id', 'uuid', 'name', 'slug', 'system_code', 'business_id', 'children'])
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
    end

    
  
    context 'when one business_id is passed' do
      let!(:response){ get("/api/service_categories/search", {business_id: 1}) }

      it 'returns 200' do
        expect(response.status).to eq(200)
      end

      it 'returns Service Categories by business_id' do
        expect(body['data'].length).to eq(6)
      end
    end

    context 'when two business_ids are passed' do
      let!(:response){ get("/api/service_categories/search", {business_id: '1,3'}) }

      it 'returns 200' do
        expect(response.status).to eq(200)
      end

      it 'returns Service Categories by business_ids' do
        expect(body['data'].length).to eq(16)
      end
    end

    context 'when invalid' do
      let!(:response){ get("/api/service_categories/search", {business_id: nil}) }

      it 'returns 422' do
        expect(response.status).to eq(422)
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
      let!(:response) { patch("/api/service_categories?id=#{service_category.id}", { uuid: 'new-id' } ) }
  
      it 'updates a Service Category' do
        service_category.reload
        
        expect(service_category.uuid).to eql('new-id')
      end
    end
  
    context 'with invalid paramters' do
      let!(:response) { patch("/api/service_categories?id=#{service_category.id}", { invalid: true } ) }

      it 'returns http error' do
        expect(response.status).to eql(422)
      end

      it 'returns error messages' do
        expect(body.keys).to eql(['error'])
      end
    end

    context 'with error on update duplicate values' do
      let!(:new_service_category) { create(:service_category) }
      let!(:response) { patch("/api/service_categories?id=#{service_category.id}", {uuid: new_service_category.uuid} ) }

      it 'returns http error' do
        expect(response.status).to eql(422)
      end

      it 'returns key message' do
        expect(body.keys).to eql(['error'])
      end

      it 'returns error message' do
        expect(body).to eql({"error"=>"Validation failed: Uuid has already been taken"})
      end
    end
  end

  describe '#delete' do
    let!(:service_category) { create(:service_category) }
    before do
      create_list(:service_category, 10, parent_id: service_category.id)
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
          expect(body).to eql({'error' => 'Invalid response'})
        end
      end
    end
  end
end
