class AddReferencesToServicePriceVariations < ActiveRecord::Migration[6.0]
  def change
    add_reference :service_price_variations, :service_price_rule, foreign_key: true, null: false, index: true
  end
end
