# Returns all possible combinations based on ServicePriceRule and ServicePriceVariation classes
# Example => ServicePriceCombinationCreator.new(service_price_rules).call
class ServicePriceCombinationCreator
  def initialize(service_price_rules)
    @service_price_rules = service_price_rules
  end

  def call
    service_price_rules.each do |rule|
      variations = rule.service_price_variations.pluck :variations

      combinations = build_combinations(variations)

      create_combinations_with_prices(combinations, rule)
    end
  end

  private

  attr_reader :service_price_rules

  # only builds the combinations based in variations attribute of the service_price_variations
  def build_combinations(variations)
    head, *rest = variations

    head.product *rest
  end

  # Creates combinations with your prices
  def create_combinations_with_prices(records, rule)
    records.each do |record|
      ActiveRecord::Base.transaction do
        service_price_combination = rule.service_price_combinations.create(name: record.join(' '))

        if service_price_combination
          create_price(service_price_combination)
        end
      end
    end
  end

  # Creates price
  def create_price(object)
    BusinessServicePrice.create(service_price_combination: object)
  end
end
