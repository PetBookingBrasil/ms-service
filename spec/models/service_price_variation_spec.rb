require 'rails_helper'

describe ServicePriceVariation, type: :model do
  subject { create(:service_price_variation, :size) }

  describe 'associations' do
    it { is_expected.to belong_to(:service_price_rule) }
  end

  describe 'validates' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:priority) }
    it { is_expected.to validate_presence_of(:kind) }
    it do
      is_expected.to validate_uniqueness_of(:priority)
               .scoped_to(:service_price_rule_id).with_message('A prioridade deve ser única por regra')
    end
  end
end
