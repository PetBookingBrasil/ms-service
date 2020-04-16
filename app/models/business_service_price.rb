class BusinessServicePrice < ApplicationRecord
  belongs_to :service_price_combination

  # TODO Validates business_service_id when there is BusinessService class
  validates :service_price_combination_id, presence: true
end
