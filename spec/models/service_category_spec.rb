require 'faker'
require 'rails_helper'

RSpec.describe ServiceCategory, type: :model do
  describe "Validations of Service Category" do
    let!(:service_category_invalid){ build(:service_category_invalid) }
    let!(:service_category){ create(:service_category) }
    # let!(:service_category_with_parent){ create(:service_category, :with_parent) }
    
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
      subject do
        service_category = create(:service_category)
        with_parent = ServiceCategory.create(attributes_for(:service_category, parent: service_category))
        with_parent
      end
      
      it "should have parent error" do
        subject.attributes = service_category_invalid.attributes
        subject.parent_id = 999
        expect(subject.parent).to be_nil
      end
    end
  end

  # describe "Service categories with Three" do
  #   before do
  #     create_list(:service_category, 10)
  #     ServiceCategory.roots.each do |service_category_root|
  #       10.times.each do |t|
  #         create(:service_category, parent: service_category_root)
  #       end
  #     end
  #   end

  #   context "only one level with childrens" do
  #     subject { ServiceCategory.root }
  #     it "behaves like" do
  #       expect(subject.hash_tree.count).to eql(10)
  #     end
  #   end
  # end
  
  
end
