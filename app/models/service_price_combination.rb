class ServicePriceCombination < ApplicationRecord
  extend FriendlyId

  friendly_id :name, use: :slugged

  belongs_to :service_price_rule

  has_one :business_service_price, dependent: :destroy

  validates :name, presence: true
end
