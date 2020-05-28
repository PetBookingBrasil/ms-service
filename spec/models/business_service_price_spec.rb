require 'rails_helper'

describe BusinessServicePrice, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:service_price_combination) }
    it { is_expected.to have_one(:service) }
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:business_id).to(:service) }
  end
end
