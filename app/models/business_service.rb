class BusinessService < ApplicationRecord
  belongs_to :service, required: true

  validates :business_id, :comission_percentage, :duration, :cost, presence: true
end
