class ServicePriceRule < ApplicationRecord
  has_many :service_price_combinations, -> { order :created_at }
    has_many :business_service_prices, through: :service_price_combinations

  validates :name, :priority, :application, presence: true
end
