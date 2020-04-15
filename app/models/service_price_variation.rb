class ServicePriceVariation < ApplicationRecord
  extend Enumerize

  enumerize :kind, in: [:simple, :breed]

  validates :name, :priority, :kind, presence: true
end
