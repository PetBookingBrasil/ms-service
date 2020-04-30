# Update combinations based on ServicePriceRule and ServicePriceVariation classes
# Example => ServicePriceCombinationUpdater.new(service_price_rule).call
module Pricing
  class ServicePriceCombinationUpdater < Pricing::Base
    def initialize(service_price_rule)
      @rule = service_price_rule
    end

    def call
      variations = rule.service_price_variations.pluck :variations
      combinations = build_combinations(variations)
      combinations_updated = create_combinations_with_prices(combinations, rule)

      combinations_fix!(combinations_updated)
    end

    private

    attr_reader :rule

    # fix combinations
    def combinations_fix!(service_price_combinations_updated)
      combinations_old = rule.service_price_combinations - service_price_combinations_updated
      combinations_old.each &:destroy
    end
  end
end
