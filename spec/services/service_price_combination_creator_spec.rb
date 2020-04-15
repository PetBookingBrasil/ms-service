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
        @service_price_combinations = ServicePriceCombination.pluck(:name)
      end

      it 'returns service price combinations with priority' do
        expect(@service_price_combinations)
          .to eq ['Poodle_p_Curta', 'Poodle_p_Média', 'Poodle_p_Longa',
                  'Poodle_m_Curta', 'Poodle_m_Média', 'Poodle_m_Longa',
                  'Poodle_g_Curta', 'Poodle_g_Média', 'Poodle_g_Longa',
                  'Poodle_gg_Curta', 'Poodle_gg_Média', 'Poodle_gg_Longa',
                  'Beagle_p_Curta', 'Beagle_p_Média', 'Beagle_p_Longa',
                  'Beagle_m_Curta', 'Beagle_m_Média', 'Beagle_m_Longa',
                  'Beagle_g_Curta', 'Beagle_g_Média', 'Beagle_g_Longa',
                  'Beagle_gg_Curta', 'Beagle_gg_Média', 'Beagle_gg_Longa']
      end
    end
  end
end
