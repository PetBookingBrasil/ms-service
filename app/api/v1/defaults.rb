module V1
  module Defaults
    extend ActiveSupport::Concern

    included do
      helpers Helpers::AuthenticatorHelpers
      prefix :api
      default_format :json

      before do
        unless Consumers::AuthorizeConsumer.new(request).call
          error!({ error: "Consumer not authorized." }, 401)
        end

        # Checks if received jwt comes from an authorized consumer
        # If we can decode it, it means it is an authorized consumer
        check(headers['Jwt'])
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
