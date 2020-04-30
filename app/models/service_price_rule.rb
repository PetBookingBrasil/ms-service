class ServicePriceRule < ApplicationRecord
  has_many :service_price_combinations, -> { order :created_at }
  has_many :business_service_prices, through: :service_price_combinations
  has_many :service_price_variations, -> { order :priority }, inverse_of: :service_price_rule

  validates :name, :priority, :application, presence: true

  scope :by_application, -> value { where(application: value) }

  accepts_nested_attributes_for :service_price_variations, allow_destroy: true
end
