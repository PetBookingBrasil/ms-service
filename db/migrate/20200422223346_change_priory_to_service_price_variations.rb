class ChangePrioryToServicePriceVariations < ActiveRecord::Migration[6.0]
  def change
    remove_index :service_price_variations, name: 'index_service_price_variations_on_priority'
  end
end
