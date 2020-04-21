class RemoveColumnToServicePriceRules < ActiveRecord::Migration[6.0]
  def change
    remove_column :service_price_rules, :service_price_variations_ids
  end
end
