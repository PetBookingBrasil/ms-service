class ServicePriceVariation < ApplicationRecord
  extend Enumerize

  enumerize :kind, in: [:simple, :breed]

  belongs_to :service_price_rule

  validates :name, :priority, :kind, presence: true
  validates :priority, uniqueness: { scope: :service_price_rule_id,
                                 message: 'A prioridade deve ser única por regra',
                                 case_sensitive: false }
end
