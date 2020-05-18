module V1
  class ServiceCategories < Grape::API
    include ::V1::Defaults
    helpers Helpers::AuthenticatorHelpers, Helpers::ServiceCategoriesHelpers

    resource :service_categories do
      desc 'List Service Categories'
      get do
        service_categories = ServiceCategory.search("*").results

        present data: V1::Entities::ServiceCategory.represent(service_categories)
      end

      desc 'Search Service Categories'
      params do
        requires :where, type: Hash
      end
      get '/search' do
        service_categories = ServiceCategory.search(where: params[:where]).results

        present data: V1::Entities::ServiceCategory.represent(service_categories)
      end

      desc 'Creates a Service Category'
      params do
        requires :name, type: String
      end
      post do
        service_category = ServiceCategory.create!(service_category_params(params))
        service_category.reload
        present data: V1::Entities::ServiceCategory.represent(service_category).as_json
      end

      desc 'Updates a Service Category'
      params do
        requires :id, type: String
      end
      put do
        service_category = ServiceCategory.find(params[:id])
        service_category.update!(params)
        present data: service_category
      end

      desc 'Deletes a Service Category'
      params do
        requires :id, type: String
      end
      delete do
        service_category = ServiceCategory.find(params[:id])
        service_category.destroy!
        present data: service_category
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

        data = ServiceCategory.search('*', scope_results: scope_results).results

        present data: V1::Entities::ServiceCategory.represent(data).as_json
      end

      params do
        requires :data, type: Array
      end
      desc 'Update service_categories'
      put '/update_all' do
        service_categories = ServiceCategoryUpdater.new(params[:data]).call
        present data: V1::Entities::ServiceCategory.represent(service_categories).as_json
      end
    end
  end
end
