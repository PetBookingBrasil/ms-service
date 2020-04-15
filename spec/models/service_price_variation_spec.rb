require 'rails_helper'

describe ServicePriceVariation, type: :model do
  describe 'validates' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:priority) }
    it { should validate_presence_of(:kind) }
  end
end
