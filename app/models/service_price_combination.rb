class ServicePriceCombination < ApplicationRecord
  extend FriendlyId

  friendly_id :name, use: :slugged

  belongs_to :service_price_rule

  before_validation :system_code_generate, on: :create

  validates :name, :service_price_rule_id, :system_code, presence: true
  validates :system_code, uniqueness: true

  private

  def system_code_generate
    last_number = 0

    if object = self.class.order(:system_code).last
      last_number = object.system_code
    end

    last_number += 1

    self.system_code = last_number
  end
end
