require 'faker'
require 'rails_helper'

RSpec.describe ServiceCategory, type: :model do
  describe 'Validations of Service Category' do
    let!(:service_category_invalid){ build(:service_category_invalid) }
    let!(:service_category){ build(:service_category) }

    describe 'validations' do
      subject { service_category_invalid }

      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_presence_of(:slug) }
      it { is_expected.to validate_uniqueness_of(:slug) }
      it { is_expected.to be_invalid }
      it 'should count of errors' do
        expect(subject.valid?).to be_falsey
        expect(subject.errors).to have(2).items
        expect(subject.errors.keys).to eql([:name, :slug])
      end
    end

    describe 'save operations' do
      subject { service_category }

      context 'service category without root' do
        it { is_expected.to be_valid }
        it 'should save root service category' do
          expect(subject.save).to be_truthy
        end
      end

      context 'service category with root' do
        let(:service_category_children) { create(:service_category, :with_parent) }

        it 'should be valid' do
          expect(service_category_children).to be_valid
        end

        it 'should have parent equal' do
          expect(service_category_children.parent).not_to be_nil
        end
      end
    end
  end
end
