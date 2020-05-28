class BusinessServicePrice < ApplicationRecord
  belongs_to :service_price_combination
  belongs_to :business_service

  has_one :service, through: :business_service

  delegate :business_id, to: :service

  searchkick batch_size: 1000, settings: { "index.mapping.total_fields.limit": 100000 }

  def search_data
    attributes.merge!(
      application: service&.application,
      business_id: business_id,
      service_id: service&.id
    )
  end
end
