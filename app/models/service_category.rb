class ServiceCategory < ApplicationRecord
  self.primary_key = :uuid

  validates :name, :slug, presence: true
  validates :slug, uniqueness: true
  has_ancestry

  has_many :services

  searchkick word_start: [:name, :slug, :system_code]
end
