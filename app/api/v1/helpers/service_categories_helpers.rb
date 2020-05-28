module V1
  module Helpers
    module ServiceCategoriesHelpers
      def service_category_params(params)
        {
          name:         params[:name],
          slug:         params[:slug],
          business_id:  params[:business_id],
          parent_id:    params[:parent_id],
          application:  headers['X-Application'],
        }
      end
    end
  end
end
