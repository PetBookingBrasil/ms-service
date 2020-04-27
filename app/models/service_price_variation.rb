class ServicePriceVariation < ApplicationRecord
  extend Enumerize

  enumerize :kind, in: [:simple, :breed]

  belongs_to :service_price_rule, inverse_of: :service_price_variations

  has_many :service_price_variations, through: :service_price_rule
  has_many :service_price_combinations, through: :service_price_rule

  validates :name, :priority, :kind, presence: true
  validates :priority, uniqueness: { scope: :service_price_rule_id,
                                     message: 'A prioridade deve ser única por regra',
                                     case_sensitive: false }

  validate :should_not_have_pricing_on_update, on: :update

  private

  def variations_from_combinations
    service_price_combinations.collect do |y|
      [
        y&.business_service_price,
        y.slug.split('-')
      ]
    end
  end

  def variations_previous
    variations_change.flatten - variations_change.last
  end

  def should_not_have_pricing_on_update
    return if variations_change.blank?

    variations_previous.each do |prev|
      combination = variations_from_combinations
                      .detect { |curr| curr.last.include? prev }

      price = combination&.first&.price

      if price && price > 0
        errors.add(:base, :has_registered_price)
        break
      end
    end
  end
end
