module V1
  class ServiceCategories < Grape::API
    include ::V1::Defaults

    resource :service_categories do
      desc "Return all service categories"
      get do
        present data: ServiceCategory.all
      end
    end

  end
end