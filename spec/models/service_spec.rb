require 'faker'
require 'rails_helper'

RSpec.describe Service, type: :model do
  describe 'Validations of Service' do
    let!(:service_invalid){ build(:service_invalid) }
    
    describe 'validations' do
      subject { service_invalid } 
      
      it { is_expected.to validate_presence_of(:uuid) }
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_presence_of(:slug) }
      it { is_expected.to validate_presence_of(:application) }
      it { is_expected.to validate_presence_of(:business_id) }
      it { is_expected.to validate_uniqueness_of(:uuid) }
      it { is_expected.to validate_uniqueness_of(:slug) }
      it { is_expected.to be_invalid }
      it 'should count of errors' do
        expect(subject.valid?).to be_falsey
        expect(subject.errors).to have(6).items
        expect(subject.errors.keys).to eql([:service_category, :uuid, :name, :slug, :application, :business_id])
      end
    end

    describe 'save operations' do
      let!(:service){ build(:service) }    

      context 'positive scenario' do
        it 'should save Service' do
          expect(service.save).to be_truthy
        end
      end
    end
  end

  describe "Search with Elastic Search" do
    before do
      create_list(:service, 100)
    end

    context "without conditions" do
      
    end

    context "with conditions" do
      
    end
    
  end
  
end
