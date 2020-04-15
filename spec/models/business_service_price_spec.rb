require 'rails_helper'

describe BusinessServicePrice, type: :model do
  describe 'associations' do
    it { should belong_to(:service_price_combination) }
  end

  describe 'validates' do
    it { should validate_presence_of(:service_price_combination_id) }
  end
end
