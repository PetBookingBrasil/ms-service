module V1
  class ServicePriceRules < Grape::API
    include ::V1::Defaults

    resource :service_price_rules do
      desc "Return all service_price_rules"
      get do
        present data: V1::Entities::ServicePriceRule.represent(ServicePriceRule.all).as_json
      end
    end

  end
end