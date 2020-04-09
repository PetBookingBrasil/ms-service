require 'rails_helper'

RSpec.describe Service, type: :model do
  describe "Validations of Service" do
    context "error without ancestry" do
      let(:service_invalid){ build(:service_invalid) }
      let(:service){ create(:service) }
      it "should have errors" do
        expect(service_invalid).to be_invalid
        expect(service_invalid.errors.count).to eql(4)
        service_invalid.attributes = service.attributes
        expect(service_invalid).to be_invalid
        expect(service_invalid.errors.count).to eql(3)
      end
    end
  end
  
end
