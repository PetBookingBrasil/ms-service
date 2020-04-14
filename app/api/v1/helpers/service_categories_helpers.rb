module V1
  module Helpers
    module ServiceCategoriesHelpers
      def service_category_params(params)
        {
          uuid: params[:uuid],
          name: params[:name],
          slug: params[:slug],
          business_id: params[:business_id],
          system_code: params[:system_code],
          system_code: params[:system_code]
        }
      end
    end
  end
end