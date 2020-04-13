require 'rails_helper'

RSpec.describe ServiceCategoriesController do

  let!(:header_signature){ Faker::Internet.uuid }
  
  before do
    @request.env['X-Signature'] = header_signature
  end

  describe 'GET index with tree of Service Categories' do
    let(:body) { JSON.parse(response.body) }
    before do
      10.times do
        create_list(:service_category, 10, parent: create(:service_category))
      end
      get :index
    end
    
    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'returns service categories with childrens' do
      expect(body).to have(10).items
    end
  end

  describe 'Get Service Categories searching by business' do
    let(:body) { JSON.parse(response.body) }
    context 'when the business is informed' do
      before do
        create_list(:service_category, 10, business_id: 1)
        create_list(:service_category, 10, business_id: 2)
        create_list(:service_category, 10, business_id: 3)
        get :filter, params: {business_id: '1|3'}
      end
      
      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end
  
      it 'returns service categories by search business' do
        expect(body).to have(20).items
      end
    end

    context 'when the business is informed but not exists' do
      before do
        create_list(:service_category, 10, business_id: 1)
        get :filter, params: {business_id: '4'}
      end
      
      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end
  
      it 'returns zero service categories by search business' do
        expect(body).to have(0).items
      end
    end
    
    context 'when the business isnt informed' do
      before do
        create_list(:service_category, 10, business_id: 1)
        get :filter
      end
      
      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end
  
      it 'returns zero service categories by search business' do
        expect(body).to have(0).items
      end
    end
  end

  describe 'Endpoint to service category creation' do
    let(:body) { JSON.parse(response.body) }
    let!(:service_category) { build(:service_category, :with_parent) }

    context 'save service category root' do
      let(:valid_attributes) { attributes_for(:service_category) }

      context 'with valid paramters' do
        it 'creates a ServiceCategory' do
          expect {
            post :create, params: { service_category: valid_attributes }
          }.to change(ServiceCategory, :count).by(1)
        end
      end

      context 'with invalid paramters' do
        before do
          post :create, params: { service_category: { invalid: true } }
        end

        it 'returns http error' do
          expect(response).to have_http_status(400)
        end

        it 'returns error messages' do
          expect(body.keys).to eql(['uuid', 'name', 'slug', 'system_code'])
        end
      end
    end
    
  end
  
end
