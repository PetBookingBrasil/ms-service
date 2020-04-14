module V1
  module Helpers
    module AuthenticatorHelpers
      def encode(payload)
        JwtHelper.new(headers['X-Application']).encode(payload)
      end

      def decode(token)
        JwtHelper.new(headers['X-Application']).decode(token)
      end

      def decoded_params
        decode(params[:jwt])
      end

      def token_header
        headers['Jwt']
      end
    end
  end
end