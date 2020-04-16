require 'rails_helper'

describe ServicePriceVariation, type: :model do
  describe 'associations' do
    it { should belong_to(:service_price_rule) }
  end

  describe 'validates' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:priority) }
    it { should validate_presence_of(:kind) }
  end
end
