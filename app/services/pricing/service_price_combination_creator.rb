# Returns all possible combinations based on ServicePriceRule and ServicePriceVariation classes
# Example => ServicePriceCombinationCreator.new(service_price_rules).call
module Pricing
  class ServicePriceCombinationCreator < Pricing::Base
    def initialize(service_price_rules)
      @rules = service_price_rules
    end

    def call
      rules.each do |rule|
        variations = rule.service_price_variations.pluck :variations
        combinations = build_combinations(variations)

        create_combinations_with_prices(combinations, rule)
      end
    end

    private

    attr_reader :rules
  end
end
