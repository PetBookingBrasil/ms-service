class Service < ApplicationRecord
  belongs_to :service_category
  validates :uuid, :name, :slug, :application, :business_id, presence: true
  validates :uuid, :slug, uniqueness: true
  has_ancestry

  searchkick word_start: [:name, :slug, :application, :business_id]

  scope :by_service_category_name, -> value do
    joins(:service_category).where(ServiceCategory.arel_table[:name].eq value)
  end
end
