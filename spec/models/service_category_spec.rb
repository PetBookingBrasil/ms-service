require 'faker'
require 'rails_helper'

RSpec.describe ServiceCategory, type: :model do
  describe "Validations of Service Category" do
    context "error without ancestry" do
      let(:service_category_invalid){build(:service_category_invalid)}
      let(:service_category){create(:service_category)}
      it "should have errors" do
        expect(service_category_invalid).to be_invalid
        expect(service_category_invalid.errors.count).to eql(4)
        service_category_invalid.attributes = service_category.attributes
        expect(service_category_invalid).to be_invalid
        expect(service_category_invalid.errors.count).to eql(3)
      end
    end

    context "error with ancestry" do
      let(:service_category_invalid){build(:service_category_invalid)}
      let(:service_category_with_ancestry){create(:service_category, :with_ancestry)}
      it "should have errors" do
        expect(service_category_invalid).to be_invalid
        expect(service_category_invalid.errors.count).to eql(4)
        service_category_with_ancestry.attributes = service_category_invalid.attributes
        service_category_with_ancestry.ancestry = nil
        expect(service_category_with_ancestry).to be_invalid
        expect(service_category_with_ancestry.errors.count).to eql(4)
      end
    end
  end
  
end
