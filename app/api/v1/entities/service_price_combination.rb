module V1
  module Entities
    class ServicePriceCombination < Grape::Entity
      expose :id
      expose :name
      expose :service_price_rule_id
      expose :system_code
      expose :slug

      expose :business_service_price, using: V1::Entities::BusinessServicePrice
    end
  end
end