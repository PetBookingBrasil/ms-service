class ServiceCategory < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  self.primary_key = :uuid

  validates :name, :slug, presence: true
  validates :slug, uniqueness: true

  has_ancestry

  has_many :services

  before_create :set_default_position

  default_scope -> { order(position: :asc) }

  mount_uploader :cover_image, ServiceCategoryUploader
  mount_uploader :icon, ServiceCategoryUploader
  process_in_background :cover_image
  process_in_background :icon

  searchkick word_start: [:name, :slug, :system_code]

  private

  # ToDo add test
  def set_default_position
    current_max_position = self.class.maximum(:position) || 1
    self.position ||= 1 + current_max_position
  end
end
