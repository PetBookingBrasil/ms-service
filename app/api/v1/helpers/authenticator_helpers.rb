module V1
  module Helpers
    module AuthenticatorHelpers
      def encode(payload)
        JwtHelper.new(headers['X-Application']).encode(payload)
      end

      def decode(token)
        JwtHelper.new(headers['X-Application']).decode(token)
      end

      def check(token)
        JwtHelper.new(headers['X-Application']).check(token)
      end
    end
  end
end
