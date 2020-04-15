module V1
  class Services < Grape::API
    include ::V1::Defaults
    helpers Helpers::AuthenticatorHelpers, Helpers::ServicesHelpers

    resource :services do
      desc 'List Services'
      get do
        services = Service.all
        present data: V1::Entities::Service.represent(services).as_json
      end
      
      desc 'Creates a Service'
      params do
        requires :uuid,                 type: String
        requires :name,                 type: String
        requires :slug,                 type: String
        requires :business_id,          type: String
        requires :application,          type: String
        requires :service_category_id,  type: String
      end
      post do
        service = Service.create!(service_params(params))
        present data: V1::Entities::Service.represent(service).as_json
      end

      desc 'Updates a Service'
      params do
        requires :id, type: Integer
      end
      patch do
        service = Service.find(params[:id])
        service.update!(params)
        present data: service
      end

      desc 'Deletes a Service'
      params do
        requires :id, type: Integer
      end
      
      delete do
        service = Service.find(params[:id])
        service.destroy!
        present data: service
      end

    end
  end
end
