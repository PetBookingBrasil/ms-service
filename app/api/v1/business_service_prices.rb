module V1
  class BusinessServicePrices < Grape::API
    include ::V1::Defaults
    helpers Helpers::AuthenticatorHelpers

    resource :business_service_prices do
      desc "Lists business service prices"
      get do
        present data: V1::Entities::BusinessServicePrice.represent(
          BusinessServicePrice.all
        ).as_json
      end

      desc 'Search business service prices'
      params do
        requires :where, type: Hash
      end
      get '/search' do
        prices = BusinessServicePrice.search('*', where: params[:where]).results

        present data: V1::Entities::BusinessServicePrice.represent(prices)
      end

      desc 'Updates business service price'
      params do
        requires :id, type: String
        requires :price, type: BigDecimal
      end
      put do
        price = BusinessServicePrice.find params[:id]
        if price.update(params)
          present data: V1::Entities::BusinessServicePrice.represent(@price)
        end
      end
    end
  end
end
