require 'faker'
require 'rails_helper'

RSpec.describe Service, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:service_category).optional(true) }
    it { is_expected.to have_one(:business_service) }
  end

  describe 'Validations of Service' do
    let!(:service_invalid) { build(:service_invalid) }

    describe 'validations' do
      subject { service_invalid }

      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_presence_of(:application) }
      it { is_expected.to validate_presence_of(:business_id) }
      it { is_expected.to be_invalid }
      it 'should count of errors' do
        expect(subject.valid?).to be_falsey
        expect(subject.errors).to have(3).items
        expect(subject.errors.keys).to eql([:name, :application, :business_id])
      end
    end

    describe 'save operations' do
      let!(:service) { build(:service) }

      context 'positive scenario' do
        it 'should save Service' do
          expect(service.save).to be_truthy
        end
      end

      context "when have parent" do
        let(:parent) { service }
        before do
          parent.save
          create_list(:service, 5)
          create_list(:service, 5, parent: parent)
        end

        it 'parent have 5 childrens' do
          expect(parent.children).to have(5).items
        end

        it 'parent have 6 roots' do
          expect(Service.roots).to have(6).items
        end
      end

    end
  end

  describe '.friendly_id' do
    let(:service) { create(:service, name: 'Service 1') }

    it { expect(service.slug).to eq('service-1') }
  end

  describe '#set_service_category_if_none' do
    context 'when there is service category' do
      let!(:service_category_one) { create(:service_category, name: 'Category 1', business_id: 1) }
      let!(:service_category_other) { create(:service_category, name: 'Outros', business_id: 1, position: 10) }
      let(:service) { create(:service, name: 'Service 1', service_category_id: nil) }

      it { expect(service.service_category.name).to eq('Outros') }
      it { expect(service.service_category.business_id).to eq(1) }
      it { expect { service }.to change(ServiceCategory, :count).by(0) }
    end

    context 'when there is not service category' do
      let!(:service_category_one) { create(:service_category, name: 'Category 1', business_id: 1) }
      let(:service) { create(:service, name: 'Service 1', service_category_id: nil) }

      it { expect(service.service_category.name).to eq('Outros') }
      it { expect(service.service_category.business_id).to eq(1) }
      it { expect { service }.to change(ServiceCategory, :count).by(1) }
    end
  end

  describe '#create_business_service' do
    let(:service) { build(:service, duration: 10) }

    context 'when to create service, should create business service' do
      it do
        expect { service.save }.to change(BusinessService, :count).by(1)
      end

      %i(duration comission_percentage business_id).each do |field|
        it do
          service.save
          expect(service.reload.business_service.send(field)).to eq(service.send(field))
        end
      end
    end
  end
end
