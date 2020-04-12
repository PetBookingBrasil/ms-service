require 'faker'
require 'rails_helper'

RSpec.describe ServiceCategory, type: :model do
  describe "Validations of Service Category" do
    let!(:service_category_invalid){ build(:service_category_invalid) }
    let!(:service_category){ create(:service_category) }
    
    describe "validations" do
      subject { service_category_invalid } 
      
      it { is_expected.to validate_presence_of(:uuid) }
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_presence_of(:slug) }
      it { is_expected.to validate_presence_of(:system_code) }
      it { is_expected.to validate_uniqueness_of(:uuid) }
      it { is_expected.to validate_uniqueness_of(:slug) }
      it { is_expected.to validate_uniqueness_of(:system_code) }
      it { is_expected.to be_invalid }
      it "should count of errors" do
        expect(subject.valid?).to be_falsey
        expect(subject.errors).to have(4).items
      end
    end

    describe "error with parent" do
      subject { create(:service_category, parent: create(:service_category)) }
      
      it "should have parent error" do
        subject.parent_id = 999
        expect(subject.parent).to be_nil
      end
    end
  end
end
