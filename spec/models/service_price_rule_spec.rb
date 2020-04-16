require 'rails_helper'

describe ServicePriceRule, type: :model do
  describe 'associations' do
    it { should have_many(:service_price_combinations) }
    it { should have_many(:business_service_prices).through(:service_price_combinations) }
  end

  describe 'validates' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:priority) }
    it { should validate_presence_of(:application) }
  end
end
