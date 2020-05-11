class ServiceCategory < ApplicationRecord
  extend FriendlyId
  include AASM

  enum aasm_state: [:disabled, :enabled]

  friendly_id :name, use: [:scoped, :slugged], scope: :business_id

  self.primary_key = :uuid

  validates :name, :slug, presence: true
  validates :slug, uniqueness: true

  has_ancestry

  has_many :services

  before_validation :set_default_position

  default_scope -> { order(position: :asc) }
  scope :by_business, -> value { where(business_id: value) }
  scope :by_business_and_name, -> *business, name do
    where('LOWER(name) = ?', name.downcase).by_business(business)
  end

  mount_uploader :cover_image, ServiceCategoryUploader
  mount_uploader :icon, ServiceCategoryUploader
  process_in_background :cover_image
  process_in_background :icon

  searchkick word_start: [:name, :slug, :system_code],
             batch_size: 1000, settings: { "index.mapping.total_fields.limit": 100000 }

  aasm whiny_transitions: false, enum: true do
    state :enabled, initial: true
    state :disabled

    event(:enable) { transitions from: :disabled, to: :enabled }
    event(:disable) { transitions from: :enabled, to: :disabled }
  end

  private

  def set_default_position
    return if position.present? || business_id.nil?

    current_max_position = self.class.by_business(business_id).maximum(:position) || 0
    self.position = 1 + current_max_position
  end
end
