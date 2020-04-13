require 'faker'
require 'rails_helper'

RSpec.describe ServiceCategory, type: :model do
  describe "Validations of Service Category" do
    let!(:service_category_invalid){ build(:service_category_invalid) }
    let!(:service_category){ build(:service_category) }
    
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

    describe 'save operations' do
      subject { service_category }

      context "service category without root" do
        it { is_expected.to be_valid }
        it "should save root service category" do
          expect(subject.save).to be_truthy
        end
      end

      context "service category with root" do
        before do
          service_category.save
        end

        let(:service_category_children) { create(:service_category, parent: service_category) }

        it "should be valid" do
          expect(service_category_children).to be_valid
        end

        it "should have parent equal" do
          expect(service_category_children.parent).to eql(service_category)
        end
      end
      
    end
  end
end
