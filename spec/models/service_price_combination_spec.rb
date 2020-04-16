require 'rails_helper'

describe ServicePriceCombination, type: :model do
  subject { create(:service_price_combination) }

  describe 'associations' do
    it { should belong_to(:service_price_rule) }

    it { should have_one(:business_service_price) }
  end

  describe 'validates' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:service_price_rule_id) }
    it { should validate_presence_of(:system_code) }
    it { should validate_uniqueness_of(:system_code) }
  end

  describe '#system_code_generate' do
    context 'when creates service price combination' do
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
