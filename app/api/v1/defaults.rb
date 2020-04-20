module V1
  module Defaults
    extend ActiveSupport::Concern
    included do
      prefix :api
      version 'v1', using: :header, vendor: :petbooking
      default_format :json

      helpers do
        def permitted_params
          @permitted_params ||= declared(params, include_missing: false)
        end

        def logger
          Rails.logger
        end
      end

      rescue_from ActiveRecord::RecordNotFound do |e|
        error_response(message: e.message, status: 404)
      end

      rescue_from ActiveRecord::RecordInvalid do |e|
        error_response(message: e.message, status: 422)
      end

      rescue_from JWT::VerificationError do |e|
        error_response(message: e.message, status: 422)
      end

      rescue_from Grape::Exceptions::ValidationErrors do |e|
        error!(e, 422).as_json
      end

      rescue_from Exception do |e|
        error_response(message: e.message, status: 422)
      end
    end
  end
end
