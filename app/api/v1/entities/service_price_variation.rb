module V1
  module Entities
    class ServicePriceVariation < Grape::Entity
      expose :id
      expose :name
      expose :variations
      expose :priority
      expose :kind
      expose :service_price_rule_id
    end
  end
end