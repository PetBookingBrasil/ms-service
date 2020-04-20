require 'rails_helper'

describe ServicePriceRule, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:service_price_combinations) }
    it { is_expected.to have_many(:business_service_prices).through(:service_price_combinations) }
    it { is_expected.to have_many(:service_price_variations) }
  end

  describe 'validates' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:priority) }
    it { is_expected.to validate_presence_of(:application) }
  end
end
