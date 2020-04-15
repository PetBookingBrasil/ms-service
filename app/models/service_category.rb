class ServiceCategory < ApplicationRecord
  validates :uuid, :name, :slug, :system_code, presence: true
  validates :uuid, :slug, :system_code, uniqueness: true
  has_ancestry

  has_many :services

  searchkick word_start: [:name, :slug, :system_code]

  def search_data
    attributes.merge(
      services: services,
      children: self.all
    )
  end
end
