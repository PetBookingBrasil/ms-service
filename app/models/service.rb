class Service < ApplicationRecord
  belongs_to :service_category
  validates :uuid, :name, :slug, :application, :business_id, presence: true
end
