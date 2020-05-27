module V1
  module Helpers
    module ServicesHelpers
      def service_params(params)
        {
          id:                   params[:id],
          name:                 params[:name],
          business_id:          params[:business_id],
          application:          params[:application],
          service_category_id:  params[:service_category_id],
          description:          params[:description],
          ancestry:             params[:ancestry],
          deleted_at:           params[:deleted_at],
          comission_percentage: params[:comission_percentage],
          price:                params[:price],
          iss_type:             params[:iss_type],
          aasm_state:           params[:aasm_state],
          duration:             params[:duration]
        }
      end
    end
  end
end
