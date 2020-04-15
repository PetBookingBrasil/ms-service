class ServicePriceRule < ApplicationRecord
  has_many :service_price_combinations, -> { order :created_at }

  validates :name, :priority, :application, presence: true
end
