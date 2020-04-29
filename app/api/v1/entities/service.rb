module V1
  module Entities
    class Service < Grape::Entity
      expose :id
      expose :uuid
      expose :name
      expose :slug
      expose :business_id
      expose :application
      expose :service_category, using: V1::Entities::ServiceCategory
      expose :children, using: V1::Entities::Service
    end
  end
end
