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

        @service_price_combinations = service_price_rule.reload.service_price_combinations.pluck(:name)
      end

      it 'returns service price combinations with priority' do
        expect(@service_price_combinations)
          .to eq ['p_curta', 'p_média', 'p_longa', 'm_curta', 'm_média', 'm_longa', 'g_curta', 'g_média',
                  'g_longa', 'gg_curta', 'gg_média', 'gg_longa']

      end
    end

    context 'when creates with breed and simple variations' do
      let(:service_price_variation_coat) do
        create(:service_price_variation, :coat, variations: ['Curta', 'Média', 'Longa'])
      end

      let(:service_price_variation_breed) do
        create(:service_price_variation, :breed, variations: ['Poodle', 'Beagle'])
      end

      let!(:service_price_rule) do
        create(:service_price_rule,
               service_price_variations_ids: [
                 service_price_variation_coat.id,
                 service_price_variation_breed.id
               ]
        )
      end

      before do
        described_class.new([service_price_rule]).call
        @service_price_combinations = ServicePriceCombination.pluck(:name)
      end

      it 'returns service price combinations with priority' do
        expect(@service_price_combinations)
          .to eq [
                   'Poodle_Curta', 'Poodle_Média', 'Poodle_Longa',
                   'Beagle_Curta', 'Beagle_Média', 'Beagle_Longa'
                 ]
      end
    end
  end
end
