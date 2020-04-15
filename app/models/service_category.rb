class ServiceCategory < ApplicationRecord
  validates :uuid, :name, :slug, :system_code, presence: true
  validates :uuid, :slug, :system_code, uniqueness: true
  has_ancestry

  searchkick word_start: [:name, :slug, :system_code]
end
