module V1
  module Helpers
    module ServicesHelpers
      def service_params(params)
        {
          id:                   params[:id],
          name:                 params[:name],
          slug:                 params[:slug],
          business_id:          params[:business_id],
          application:          params[:application],
          service_category_id:  params[:service_category_id]
        }
      end
    end
  end
end
