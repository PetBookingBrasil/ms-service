class BusinessServicePrice < ApplicationRecord
  belongs_to :service_price_combination

  validates :service_price_combination_id, presence: true
end
