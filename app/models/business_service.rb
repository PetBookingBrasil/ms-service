class BusinessService < ApplicationRecord
  belongs_to :service, required: true

  validates :business_id, :comission_percentage, :duration, :cost, presence: true

  searchkick batch_size: 1000, settings: { "index.mapping.total_fields.limit": 100000 }
end
