require 'rails_helper'

RSpec.describe BusinessService, type: :model do
  let!(:business_service_invalid){ build(:business_service_invalid) }
  let!(:business_service){ build(:business_service) }
  
  describe 'validations' do
    subject { business_service_invalid } 
    
    it { is_expected.to validate_presence_of(:business_id) }
    it { is_expected.to validate_presence_of(:comission_percentage) }
    it { is_expected.to validate_presence_of(:duration) }
    it { is_expected.to validate_presence_of(:cost) }
    it { is_expected.to be_invalid }
    it 'should count of errors' do
      expect(subject.valid?).to be_falsey
      expect(subject.errors).to have(5).items
    end
  end
end
