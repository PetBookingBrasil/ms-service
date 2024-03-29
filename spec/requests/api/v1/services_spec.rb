require 'spec_helper'

RSpec.describe ::V1::Services, type: :request do
  include Rack::Test::Methods

  let(:jwt_helper) { JwtHelper.new("petbooking") }
  let(:body) { JSON.parse(response.body) }
  let!(:service) { create(:service) }
  let!(:service_category) { create(:service_category) }

  before do
    header "Accept", "application/vnd.petbooking-v1+json"
    header "X-Application", "petbooking"
    header "Jwt", jwt_helper.encode("abc123")
  end

  describe '#index' do
    before do
      create_list(:service, 10, service_category_id: service_category.id)
      Service.reindex
    end

    let!(:response){ get("/api/services") }

  	context 'when valid' do
      it 'returns 200' do
        expect(response.status).to eq(200)
      end

      it 'returns correct hash structure' do
        expect(body.keys).to eql(["data"])
        expect(body["data"].first.keys).to eql(["id", "uuid", "name", "slug", "business_id", "application", "service_category", "children"])
      end

      it 'returns Service list' do
        expect(body["data"]).to have(10).items
      end
    end
  end

  describe 'grouped by Service Category and filter by Services applications' do
    before do
      create_list(:service_category, 5) do |root_service_category|

        create_list(:service, 5, service_category: root_service_category, application: service.application).each do |root_service|
          create_list(:service, 5, :petbooking,  parent: root_service, service_category: root_service_category)
        end
      end
      Service.reindex
      ServiceCategory.reindex
    end

    let(:first_service) { Service.first }

    let(:response) { get("/api/services/grouped_by_category?application=#{first_service.application}") }

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'have exactly structure' do
      expect(body.keys).to eql(['data'])
      expect(body['data'].first.keys).to eql(['service_category', 'services'])
      expect(Service.count).to eql(151)

    end

    it "have Service root with 10 items" do
      expect(Service.search("*", where: { application: service.application } )).to have(26).items
    end
  end

  describe '#by_application' do
    before do
      create_list(:service, 10, service_category_id: service_category.id, business_id: 1, application: 'varejopet')
      create_list(:service, 20, service_category_id: service_category.id, business_id: 2, application: 'varejopet')
      create_list(:service, 20, service_category_id: service_category.id, business_id: 3, application: 'varejopet')
      Service.reindex
    end



    context 'when search by one business_id' do
      let!(:response){ get("/api/services/by_application?application=varejopet&business_id=1") }

      it 'returns 200' do
        expect(response.status).to eq(200)
      end

      it 'returns correct hash structure' do
        expect(body.keys).to eql(["data"])
        expect(body["data"].first.keys).to eql(["id", "uuid", "name", "slug", "business_id", "application", "service_category", "children"])
      end
      it 'returns Service list' do
        expect(body["data"]).to have(11).items
      end


    end

    context 'when search by list of business_ids' do
      let!(:response){ get("/api/services/by_application?application=varejopet&business_id=1,3") }

      it 'returns 200' do
        expect(response.status).to eq(200)
      end

      it 'returns correct hash structure' do
        expect(body.keys).to eql(["data"])
        expect(body["data"].first.keys).to eql(["id", "uuid", "name", "slug", "business_id", "application", "service_category", "children"])
      end
      it 'returns Service list' do
        expect(body["data"]).to have(31).items
      end


    end

    context 'list without business_id' do
      let!(:response){ get("/api/services/by_application?application=varejopet") }

      it 'returns 200' do
        expect(response.status).to eq(200)
      end

      it 'returns correct hash structure' do
        expect(body.keys).to eql(["data"])
        expect(body["data"].first.keys).to eql(["id", "uuid", "name", "slug", "business_id", "application", "service_category", "children"])
      end
      
      it 'returns Service list' do
        expect(body["data"]).to have(51).items
      end


    end
  end

  describe '#create' do
    let(:valid_params) { attributes_for(:service, service_category_id: service_category.id) }

  	context 'when valid' do
      let!(:response) { post("/api/services", valid_params) }

      it 'returns 201' do
        expect(response.status).to eq(201)
      end

      it 'returns Service data' do
        expect(body['data'].symbolize_keys[:name]).to eql(valid_params[:name])
      end
    end

    context 'when invalid' do
      context 'when fail in create context' do
        let!(:response) { post("/api/services") }

        it 'returns 500' do
          expect(response.status).to eq(500)
        end
      end
    end
  end

  describe '#update' do
    context 'with valid paramters' do
      let!(:response) { patch("/api/services?id=#{service.id}", { uuid: 'new-id' } ) }

      it 'updates a Service' do
        service.reload

        expect(service.uuid).to eql('new-id')
      end
    end

    context 'with invalid paramters' do
      let!(:response) { patch("/api/services?id=#{service.id}", { invalid: true } ) }

      it 'returns http error' do
        expect(response.status).to eql(422)
      end

      it 'returns error messages' do
        expect(body.keys).to eql(['error'])
      end
    end

    context 'with error on update duplicate values' do
      let!(:new_service) { create(:service) }
      let!(:response) { patch("/api/services?id=#{service.id}", {uuid: new_service.uuid} ) }

      it 'returns http error' do
        expect(response.status).to eql(422)
      end

      it 'returns key message' do
        expect(body.keys).to eql(['error'])
      end
    end
  end

  describe '#delete' do
    let!(:service) { create(:service) }

    context 'delete Service' do
      let(:response) { delete("/api/services?id=#{service.id}") }

      it 'returns 200' do
        expect(response.status).to eq(200)
      end

      it 'returns Service' do
        expect(body['data']['id']).to eq(service.id)
      end
    end

    context 'when invalid' do
      context 'when Service does not exists' do
        let(:response) { delete("/api/services") }

        it 'returns 500' do
          expect(response.status).to eq(500)
        end

        it 'returns error message' do
          expect(body).to eql({'error' => "Invalid response"})
        end
      end
    end
  end
end
