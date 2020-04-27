module V1
  class ServicePriceRules < Grape::API
    include ::V1::Defaults

    resource :service_price_rules do
      desc "Return all service_price_rules for current application"
      get do
        present data: V1::Entities::ServicePriceRule.represent(
          ServicePriceRule.by_application(headers['X-Application'])
        ).as_json
      end

      desc 'updates service price rules'
      params do
        requires :id, type: Integer
        requires :service_price_rule, type: Hash do
          optional :name, type: String
          optional :priority, type: Integer
          optional :application, type: String
          optional :service_price_variations_attributes, type: Array do
            requires :id, type: Integer
            optional :_destroy, type: Integer
            optional :name, type: String
            optional :kind, type: String
            optional :priority, type: String
            optional :variations, type: Array
          end
        end
      end

      put do
        @service_price_rule = ServicePriceRule.find params[:id]
        if @service_price_rule.update(params[:service_price_rule])
          Pricing::ServicePriceCombinationUpdater.new(@service_price_rule).call
        end
      end
    end
  end
end
