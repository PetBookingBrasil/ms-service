module V1
  module Entities
    class BusinessServicePrice < Grape::Entity
      expose :id
      expose :business_service_id
      expose :service_price_combination_id
      expose :price
    end
  end
end