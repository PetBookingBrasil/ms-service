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
          deleted_at:           params[:deleted_at].try(:to_date),
          comission_percentage: params[:comission_percentage],
          price:                params[:price].try(:to_f),
          iss_type:             params[:iss_type],
          aasm_state:           params[:aasm_state],
          duration:             params[:duration].try(:to_i)
        }
      end
    end
  end
end
