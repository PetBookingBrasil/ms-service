require 'rails_helper'

RSpec.describe ServicesController do

  let!(:header_signature){ Faker::Internet.uuid }
  let!(:service_category) { create(:service_category) }
  let!(:valid_attributes) { attributes_for(:service, service_category_id: service_category.id ) }
  
  before do
    @request.env['X-Signature'] = header_signature
  end

  describe 'GET list of Services' do
    let(:body) { JSON.parse(response.body) }
    before do
      create_list(:service, 10, service_category: create(:service_category))
      get :index
    end
    
    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'returns service collection' do
      expect(body).to have(10).items
    end
  end

  describe 'Endpoint to create a Service' do
    let(:body) { JSON.parse(response.body) }
    let(:service) { build(:service) }
    

    context 'with valid paramters' do
      it 'create a Service' do
        expect {
          post :create, params: { service: valid_attributes }
        }.to change(Service, :count).by(1)
      end
    end

    context 'with invalid paramters' do
      before do
        post :create, params: { service: { invalid: true } }
      end

      it 'returns http error' do
        expect(response).to have_http_status(422)
      end

      it 'returns error messages' do
        expect(body.keys).to eql(['service_category', 'uuid', 'name', 'slug', 'application', 'business_id'])
      end
    end
    
  end

  # describe 'Endpoint to update a Service' do
  #   let(:body) { JSON.parse(response.body) }
  #   let(:valid_attributes) { attributes_for(:service, service_category_id: service_category.id) }
  #   let!(:service) { create(:service, service_category_id: service_category.id) }

  #   context 'with valid paramters' do
  #     before do
  #       puts service.attributes
  #       patch :update, params: { id: service.id, service: valid_attributes }
  #     end

  #     it 'updates a Service' do
  #       # service.reload
  #       # puts service.changed?
  #       # expect(service.attributes).to eql(valid_attributes)
  #     end
  #   end

    # context 'with invalid paramters' do
    #   before do
    #     put :update, params: { id: service.id, service: {  } }
    #   end

    #   it 'returns http error' do
    #     expect(response).to have_http_status(422)
    #   end

    #   it 'returns error messages' do
    #     expect(body.keys).to eql('id', 'service_category_id', 'uuid', 'name', 'slug', 'application', 'business_id', 'created_at', 'updated_at')
    #   end
    # end
  # end
  
end
