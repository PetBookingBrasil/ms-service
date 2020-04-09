require 'rails_helper'

RSpec.describe ServiceCategoriesController do

  let!(:header_signature){ Faker::Internet.uuid }
  
  before(:each) do
    @request.env['X-Signature'] = header_signature
  end

  describe "GET /index" do
    before do
      create_list(:service_category, 10, :with_ancestry)
    end
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
      expect(response.body.to_json).to eql([])
    end
  end


  # describe "GET /create" do
  #   it "returns http success" do
  #     get "/service_types/create"
  #     expect(response).to have_http_status(:success)
  #   end
  # end

  # describe "GET /update" do
  #   it "returns http success" do
  #     get "/service_types/update"
  #     expect(response).to have_http_status(:success)
  #   end
  # end

end
