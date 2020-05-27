module V1
  class Services < Grape::API
    include ::V1::Defaults
    helpers Helpers::AuthenticatorHelpers, Helpers::ServicesHelpers

    resource :services do
      desc 'List Services'
      get do
        if attributes = params[:scope]
          scope_results = -> (r) { r.send(attributes[:name], attributes[:values]) }
        end
        services = Service.search("*", { limit: 10 , scope_results: scope_results }).results

        present data: V1::Entities::Service.represent(services).as_json
      end

      desc 'List Services tree by application and and grouped by Service Category'
      get '/grouped_by_category' do
        conditions = { application: { like: "%#{params[:application] }%" } }
        if params[:business_id] != nil
          conditions = conditions.merge({ business_id: params[:business_id] })
        end
        services = Service.search("*", where: conditions, aggs: [:service_category_id] )
        services_grouped = services.group_by{|t| t.service_category_id}
        services_grouped = services_grouped.map do |service_category_id, services|
          service_category = ServiceCategory.search("*", where: { id: service_category_id } )
          {service_category: V1::Entities::ServiceCategory.represent(service_category).as_json, services: V1::Entities::Service.represent(services).as_json}
        end

        present data: services_grouped
      end

      desc 'List Services by application and business_id'
      get '/by_application' do
        where = { application: params[:application] }
        unless params[:business_id].blank?
          where.merge!({ business_id: params[:business_id].split(',') })
        end
        services = Service.search("*", where: where )
        present data: V1::Entities::Service.represent(services).as_json
      end

      desc 'Creates a Service'
      params do
        requires :name,                 type: String
        requires :business_id,          type: Integer
        requires :application,          type: String
        requires :service_category_id,  type: String
        optional :description,          type: String
        optional :ancestry,             type: String
        optional :deleted_at,           type: Date
        optional :comission_percentage, type: Float
        optional :price,                type: Float
        optional :iss_type,             type: Integer
        optional :aasm_state,           type: Integer
        optional :duration,             type: Integer
      end
      post do
        service = Service.create!(service_params(params))
        present data: V1::Entities::Service.represent(service).as_json
      end

      desc 'Updates a Service'
      params do
        requires :id, type: String
        optional :aasm_state, type: Integer
      end
      put do
        service = Service.find(params[:id])
        service.update!(service_params(params))
        present data: V1::Entities::Service.represent(service)
      end

      desc 'Deletes a Service'
      params do
        requires :id, type: String
      end

      delete do
        service = Service.find(params[:id])
        service.destroy!
        present data: service
      end

      desc 'Scope by search'
      params do
        requires :scope_name, type: String
      end
      get '/search_by_scope' do
        scope_results = -> r do
          if params[:options]
            r.send(params[:scope_name], params[:options])
          else
            r.send(params[:scope_name])
          end
        end

        data = Service.search('*', scope_results: scope_results).results

        present data: V1::Entities::Service.represent(data).as_json
      end

      desc 'Search services'
      params do
        requires :where, type: Hash
      end
      get '/search' do
        services = Service.search(where: params[:where].deep_symbolize_keys).results

        present data: V1::Entities::Service.represent(services)
      end
    end
  end
end
