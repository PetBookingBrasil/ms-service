class ServiceCategory < ApplicationRecord
  validates :uuid, :name, :slug, :system_code, presence: true
  validates :uuid, :slug, :system_code, uniqueness: true
  has_ancestry

  def self.search(search)
    self.where('uuid ILIKE :search
      OR name  ILIKE :search
      OR slug  ILIKE :search
      OR system_code ILIKE :search', {search: search})
  end
end
