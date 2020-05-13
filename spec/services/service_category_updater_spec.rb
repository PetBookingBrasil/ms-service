require 'rails_helper'

describe ServiceCategoryUpdater do
  describe '#call' do
    context 'when update service category' do
      let!(:service_category_one) do
        create(:service_category, aasm_state: 1, position: 4, uuid: 20)
      end
      let!(:service_category_two) do
        create(:service_category, aasm_state: 0, position: 5, uuid: 10)
      end

      let(:attributes_one) do
        { aasm_state: 'enabled', position: 2, id: 20 }
      end

      let(:attributes_two) do
        { aasm_state: 'enabled', position: 3, id: 10 }
      end

      let(:service_category_updater) do
        ServiceCategoryUpdater.new([attributes_one, attributes_two])
      end

      context 'when before the update' do
        it { expect(service_category_one.aasm_state).to eq 'enabled' }
        it { expect(service_category_one.position).to eq 4 }

        it { expect(service_category_two.aasm_state).to eq 'disabled' }
        it { expect(service_category_two.position).to eq 5 }
      end

      context 'when update' do
        before { service_category_updater.call }

        it { expect(service_category_one.reload.aasm_state).to eq 'enabled' }
        it { expect(service_category_one.reload.position).to eq 2 }

        it { expect(service_category_two.reload.aasm_state).to eq 'enabled' }
        it { expect(service_category_two.reload.position).to eq 3 }
      end
    end
  end
end
