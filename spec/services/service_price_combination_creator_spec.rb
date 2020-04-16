require 'rails_helper'

describe ServicePriceCombinationCreator do
  describe '#call' do
    context 'when creates simple variations' do
      let(:service_price_variation_size) { create(:service_price_variation, :size) }
      let(:service_price_variation_coat) { create(:service_price_variation, :coat) }

      let!(:service_price_rule) do
        create(:service_price_rule,
               service_price_variations_ids: [
                 service_price_variation_coat.id,
                 service_price_variation_size.id,
               ]
        )
      end

      before do
        described_class.new([service_price_rule]).call

        @service_price_combinations = service_price_rule.reload.service_price_combinations.pluck(:slug)
      end

      it 'returns service price combinations with priority' do
        expect(@service_price_combinations)
          .to eq ['p-curta', 'p-media', 'p-longa',
                  'm-curta', 'm-media', 'm-longa',
                  'g-curta', 'g-media', 'g-longa',
                  'gg-curta', 'gg-media', 'gg-longa']

      end

      context 'with prices' do
        it do
          expect { described_class.new([service_price_rule]).call }
            .to change(BusinessServicePrice, :count).by(12)
        end
      end
    end

    context 'when creates with breed and simple variations' do
      let(:service_price_variation_coat) do
        create(:service_price_variation, :coat, variations: ['Curta', 'Média', 'Longa'])
      end

      let(:service_price_variation_breed) do
        create(:service_price_variation, :breed, variations: ['Poodle', 'Beagle'])
      end

      let(:service_price_variation_size) do
        create(:service_price_variation, :size)
      end

      let!(:service_price_rule) do
        create(:service_price_rule,
               service_price_variations_ids: [
                 service_price_variation_coat.id,
                 service_price_variation_breed.id,
                 service_price_variation_size.id
               ]
        )
      end

      before do
        described_class.new([service_price_rule]).call
        @service_price_combinations = ServicePriceCombination.pluck(:slug)
      end

      it 'returns service price combinations with priority' do
        expect(@service_price_combinations)
          .to eq ['poodle-p-curta', 'poodle-p-media', 'poodle-p-longa',
                  'poodle-m-curta', 'poodle-m-media', 'poodle-m-longa',
                  'poodle-g-curta', 'poodle-g-media', 'poodle-g-longa',
                  'poodle-gg-curta', 'poodle-gg-media', 'poodle-gg-longa',
                  'beagle-p-curta', 'beagle-p-media', 'beagle-p-longa',
                  'beagle-m-curta', 'beagle-m-media', 'beagle-m-longa',
                  'beagle-g-curta', 'beagle-g-media', 'beagle-g-longa',
                  'beagle-gg-curta', 'beagle-gg-media', 'beagle-gg-longa']

      end

      context 'with prices' do
        it do
          expect { described_class.new([service_price_rule]).call }
            .to change(BusinessServicePrice, :count).by(24)
        end
      end
    end
  end
end
