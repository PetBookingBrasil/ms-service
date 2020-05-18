module V1
  module Entities
    class ServiceCategory < Grape::Entity
      expose :id
      expose :name
      expose :slug
      expose :cover_image
      expose :cover_image_cache
      expose :icon
      expose :icon_cache
      expose :html_class_name
      expose :position
      expose :aasm_state
      expose :system_code
      expose :business_id
      expose :children, using: V1::Entities::ServiceCategory
    end
  end
end
