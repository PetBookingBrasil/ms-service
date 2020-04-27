require 'rails_helper'

describe ServicePriceVariation, type: :model do
  subject { create(:service_price_variation, :size) }

  describe 'associations' do
    it { is_expected.to belong_to(:service_price_rule) }
  end

  describe 'validates' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:priority) }
    it { is_expected.to validate_presence_of(:kind) }
    it do
      is_expected.to validate_uniqueness_of(:priority)
                       .scoped_to(:service_price_rule_id).with_message('A prioridade deve ser única por regra')
    end
  end

  describe '#should_not_have_pricing_on_update' do
    let(:service_price_rule) { create(:service_price_rule) }

    let!(:service_price_variation_size) do
      create(:service_price_variation,
             :size,
             service_price_rule: service_price_rule,
             variations: ['p', 'g'])
    end
    let!(:service_price_variation_coat) do
      create(:service_price_variation,
             :coat,
             service_price_rule: service_price_rule,
             variations: ['curto', 'longo'])
    end

    let!(:combination_with_prices) do
      %i(p-curto p-longo g-curto g-longo).each do |variation|
        service_price_combination = create(:service_price_combination,
                                           service_price_rule: service_price_rule,
                                           name: variation)

       create(:business_service_price,
                                        service_price_combination: service_price_combination,
                                        price: 0)
      end
    end

    context 'when there is price registered for service price variations' do
      before do
        combination = ServicePriceCombination.find_by(slug: 'g-curto')
        combination.business_service_price.update_attribute(:price, 30.00)
      end

      it do
        service_price_variation_size.variations = ['p', 'gg']
        service_price_variation_size.valid?

        expect(service_price_variation_size.errors[:base])
          .to include 'Variação que tenha preço cadastrado, não deve ser alterada.'
      end
    end

    context 'when there is not price registered for service price variations' do
      it do
        service_price_variation_size.variations = ['p', 'gg']
        service_price_variation_size.valid?

        expect(service_price_variation_size.errors[:base])
          .to_not include 'Variação que tenha preço cadastrado, não deve ser alterada.'
      end
    end
  end
end
