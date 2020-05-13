class Service < ApplicationRecord
  include BitmaskOptions
  include AASM

  enum aasm_state: [:disabled, :enabled]

  belongs_to :service_category
  validates :uuid, :name, :slug, :application, :business_id, presence: true
  validates :uuid, :slug, uniqueness: true
  has_ancestry

  searchkick word_start: [:name, :slug, :application, :business_id]

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
  scope :described,     -> { where('char_length(description) > 0') }
  scope :not_described, -> { where('char_length(description) = 0') }

  aasm whiny_transitions: false, enum: true do
    state :enabled, initial: true
    state :disabled

    event(:enable) { transitions from: :disabled, to: :enabled }
    event(:disable) { transitions from: :enabled, to: :disabled }
  end
end
