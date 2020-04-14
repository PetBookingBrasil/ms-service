module V1
  module Entities
    class ServiceCategory < Grape::Entity
      expose :id
      expose :uuid
      expose :name
      expose :slug
      expose :system_code
      expose :business_id
      expose :parent, using: V1::Entities::ServiceCategory
    end
  end
end