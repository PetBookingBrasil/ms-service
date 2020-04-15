class ServicePriceCombinationCreator
  def initialize(service_price_rules)
    @service_price_rules = service_price_rules
  end

  def call
    service_price_rules.each do |rule|
      variations = service_price_variations(rule.service_price_variations_ids)

      combinations = build_combinations(variations)

      create_combinations(combinations, rule)
    end
  end

  private

  attr_reader :service_price_rules

  def service_price_variations(ids)
    @service_price_variations ||= ServicePriceVariation
                                    .where(id: ids)
                                    .order(:priority)
                                    .pluck(:variations)
  end

  def build_combinations(variations)
    head, *rest = variations

    head.product *rest
  end

  def create_combinations(combinations, rule)
    combinations.each do |combination|
      rule.service_price_combinations.create(name: combination.join('_'))
    end
  end
end
