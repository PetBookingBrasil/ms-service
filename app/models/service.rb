class Service < ApplicationRecord
  belongs_to :service_category
  validates :uuid, :name, :slug, :application, :business_id, presence: true
  validates :uuid, :slug, uniqueness: true

  searchkick word_start: [:name, :slug, :application, :business_id]
end
