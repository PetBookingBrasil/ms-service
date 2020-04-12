require 'rails_helper'

RSpec.describe ServiceCategoriesController do

  let!(:header_signature){ Faker::Internet.uuid }
  
  before do
    @request.env['X-Signature'] = header_signature
  end

  describe "GET /index" do
    let(:body) { JSON.parse(response.body) }
    before do
      10.times do
        create_list(:service_category, 10, parent: create(:service_category))
      end
      get :index
    end
    
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "returns service categories with childrens" do
      expect(body).to have(10).items
    end
    
  end
end
