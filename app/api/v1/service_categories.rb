module V1
  class ServiceCategories < Grape::API
    include ::V1::Defaults
    helpers Helpers::AuthenticatorHelpers, Helpers::ServiceCategoriesHelpers

    resource :service_categories do
      desc 'Creates a Service Category'
      params do
        requires :uuid, type: String
        requires :name, type: String
        requires :slug, type: String
        requires :system_code, type: String
      end
      post do
        service_category = ServiceCategory.create!(role_params(params))
        present data: service_category
      end

      desc 'Shows Service Categories'
      get do
        service_categories = ServiceCategory.arrange_serializable
        present data: service_categories
      end

      desc 'Updates a Service Category'
      put do
        service_category = ServiceCategory.find(params[:id])
        service_category.update!(service_category_params(params))
        present data: service_category
      end

      desc 'Deletes a Service Category'
      delete do
        service_category = ServiceCategory.find(params[:id])
        service_category.destroy!
        present data: service_category
      end

    end
  end
end