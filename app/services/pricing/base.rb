module Pricing
  class Base
    # Creates combinations with your prices
    def create_combinations_with_prices(records, rule)
      combinations = []

      records.each do |record|
        ActiveRecord::Base.transaction do
          service_price_combination = rule.service_price_combinations
                                        .find_or_create_by(name: record.join(' '))

          combinations <<  service_price_combination

          if service_price_combination.business_service_price.blank?
            create_price(service_price_combination)
          end
        end
      end

      combinations
    end

    # Creates price
    def create_price(object)
      BusinessServicePrice.create(service_price_combination: object)
    end

    # only builds the combinations based in variations attribute of the service_price_variations
    def build_combinations(variations)
      head, *rest = variations

      head.product *rest
    end
  end
end
