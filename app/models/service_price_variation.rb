class ServicePriceVariation < ApplicationRecord
  extend Enumerize

  enumerize :kind, in: [:simple, :breed]

  belongs_to :service_price_rule

  validates :name, :priority, :kind, presence: true
end
