require 'rails_helper'

describe ServicePriceCombination, type: :model do
  subject { create(:service_price_combination) }

  describe 'associations' do
    it { is_expected.to belong_to(:service_price_rule) }

    it { is_expected.to have_one(:business_service_price).dependent(:destroy) }
  end

  describe 'validates' do
    it { is_expected.to validate_presence_of(:name) }
  end
end
