class ServiceCategory < ApplicationRecord
  extend FriendlyId
  include AASM

  enum aasm_state: [:disabled, :enabled]

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

  aasm whiny_transitions: false, enum: true do
    state :enabled, initial: true
    state :disabled

    event(:enable) { transitions from: :disabled, to: :enabled }
    event(:disable) { transitions from: :enabled, to: :disabled }
  end

  private

  # ToDo add test
  def set_default_position
    current_max_position = self.class.maximum(:position) || 1
    self.position ||= 1 + current_max_position
  end
end
