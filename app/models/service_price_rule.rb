class ServicePriceRule < ApplicationRecord
  has_many :service_price_combinations, -> { order :created_at }
  has_many :business_service_prices, through: :service_price_combinations
  has_many :service_price_variations, -> { order :priority }

  validates :name, :priority, :application, presence: true
end
