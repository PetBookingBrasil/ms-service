require 'rails_helper'

RSpec.describe ServiceCategoriesController do

  let!(:header_signature){ Faker::Internet.uuid }
  
  before(:each) do
    @request.env['X-Signature'] = header_signature
  end

  describe "GET /index" do
    before do
      create_list(:service_category, 10)
    end
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
      body = JSON.parse(response.body)
      expect(body).to have(10).items
    end
  end
end
