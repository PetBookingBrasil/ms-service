require 'rails_helper'

describe BusinessServicePrice, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:service_price_combination) }
  end
end
