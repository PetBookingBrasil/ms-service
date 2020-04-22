module V1
  module Entities
    class ServicePriceRule < Grape::Entity
      expose :id
      expose :name
      expose :priority
      expose :application

      expose :service_price_combinations, using: V1::Entities::ServicePriceCombination
      expose :business_service_prices, using: V1::Entities::BusinessServicePrice
      expose :service_price_variations, using: V1::Entities::ServicePriceVariation
    end
  end
end