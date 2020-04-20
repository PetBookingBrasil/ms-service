require 'rails_helper'

describe ServicePriceCombination, type: :model do
  subject { create(:service_price_combination) }

  describe 'associations' do
    it { is_expected.to belong_to(:service_price_rule) }

    it { is_expected.to have_one(:business_service_price) }
  end

  describe 'validates' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:system_code) }

    context 'uniqueness' do
      before do
        ServicePriceCombination.skip_callback(:validation, :before, :system_code_generate)
      end

      it { is_expected.to validate_uniqueness_of(:system_code) }
    end
  end

  describe '#system_code_generate' do
    context 'when creates service price combination' do
      before do
        ServicePriceCombination.set_callback(:validation, :before, :system_code_generate)
      end

      context 'for first time' do
        it do
          subject
          expect(subject.system_code.to_i).to eq 1
        end
      end

      context 'with existing records' do
        let!(:service_price_combination_one) { create(:service_price_combination) }
        let(:service_price_combination_two) { create(:service_price_combination) }

        it { expect(service_price_combination_two.system_code).to eq 2 }
      end
    end
  end
end
