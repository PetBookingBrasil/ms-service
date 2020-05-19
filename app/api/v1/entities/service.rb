module V1
  module Entities
    class Service < Grape::Entity
      format_with(:aasm_state_before_type_cast) do |value|
        value == 'enabled' ? 1 : 0
      end
      expose :id
      expose :name
      expose :slug
      expose :business_id
      expose :application
      expose :service_category_id
      with_options(format_with: :aasm_state_before_type_cast) do
        expose :aasm_state
      end
      expose :service_category, using: V1::Entities::ServiceCategory
      expose :children, using: V1::Entities::Service
    end
  end
end
