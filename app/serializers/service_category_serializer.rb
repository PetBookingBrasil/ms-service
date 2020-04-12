class ServiceCategorySerializer < ActiveModel::Serializer
  attributes :id, :uuid, :name, :slug, :system_code
end
