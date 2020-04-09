class ServiceCategory < ApplicationRecord
  scope :without_ancestry, -> { where(ancestry_id: nil) }
  validates :uuid, :name, :slug, :system_code, presence: true
  validates :uuid, :slug, :system_code, uniqueness: true

  belongs_to :ancestry,  foreign_key: "ancestry_id", class_name: 'ServiceCategory', optional: true
end
