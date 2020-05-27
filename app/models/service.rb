class Service < ApplicationRecord
  include BitmaskOptions
  include AASM
  extend FriendlyId

  enum aasm_state: [:disabled, :enabled]

  friendly_id :name, use: [:scoped, :slugged], scope: :service_category_id

  before_create :set_service_category_if_none

  belongs_to :service_category, optional: true

  validates :name, :application, :business_id, presence: true

  has_ancestry

  searchkick word_start: [:name, :slug, :application, :business_id],
             batch_size: 100,
             settings: { "index.mapping.total_fields.limit": 100000 },
             locations: [:search_location]

  has_bitmask_options [
                        ['has_online_scheduling', 'O cliente pode agendar online'], # 2 ** 0 => 1
                        ['has_price_upon_request', 'Preço sob consulta'], # 2 ** 1 => 2
                        ['has_price_starting_at', 'Preço a partir de'], # 2 ** 2 => 4
                        ['has_online_payment', 'O cliente pode pagar online'] # 2 ** 4 => 8
                      ]

  scope :by_service_category_name, lambda { |options = {}|
    joins(:service_category).where(ServiceCategory.arel_table[:name].eq options[:name])
  }

  scope :configured, -> { enabled.where(self.arel_table[:duration].gt(0)) }
  scope :reschedulable, -> { where(self.arel_table[:reschedule_reminder_days_after].gt(0)) }
  scope :described, -> { where('char_length(description) > 0') }
  scope :not_described, -> { where('char_length(description) = 0') }
  scope :configured_with_online_scheduling, lambda { |options = {}|
    ids = options.fetch(:ids) { self.pluck(:id) }

    where(id: ids).configured.with_online_scheduling
  }

  default_scope { where(deleted_at: nil) }

  aasm whiny_transitions: false, enum: true do
    state :enabled, initial: true
    state :disabled

    event(:enable) { transitions from: :disabled, to: :enabled }
    event(:disable) { transitions from: :enabled, to: :disabled }
  end

  def search_data
    attributes.merge(
      service_category_business_id: service_category&.business_id,
      type: 'service',
      aasm_state: aasm_state.to_s,
      has_online_scheduling: has_online_scheduling
    )
  end

  private

  def set_service_category_if_none
    sc = ServiceCategory
           .create_with(business_id: business_id)
           .by_business(business_id)
           .find_or_create_by(name: 'Outros', position: 10)

    self.service_category ||= sc
  end
end
