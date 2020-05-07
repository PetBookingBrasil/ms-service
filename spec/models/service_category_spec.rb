require 'faker'
require 'rails_helper'

RSpec.describe ServiceCategory, type: :model do
  describe 'state machine' do
    it { is_expected.to have_state(:enabled) }
    it do
      service_category = described_class.new

      expect(service_category).to be_enabled
    end
    it do
      is_expected.to transition_from(:enabled)
                       .to(:disabled).on_event(:disable)
    end

    it do
      is_expected.to transition_from(:disabled)
                       .to(:enabled).on_event(:enable)
    end
  end

  describe '.friendly_id' do
    let(:service_category) { create(:service_category, business_id: 1, name: 'Categoria 1') }

    it { expect(service_category.slug).to eq('categoria-1') }
  end

  describe '#set_default_position' do
    let!(:service_category_one) { create(:service_category, business_id: 2, position: 1) }
    let!(:service_category_two) { create(:service_category, business_id: 1, position: 1) }
    let(:service_category_three) { create(:service_category, business_id: 1, position: nil) }

    it { expect(service_category_three.position).to eq 2 }
  end

  describe 'Validations of Service Category' do
    let!(:service_category_invalid) { build(:service_category_invalid) }
    let!(:service_category) { build(:service_category) }

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
