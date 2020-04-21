class CreateServicePriceRules < ActiveRecord::Migration[6.0]
  def change
    create_table :service_price_rules do |t|
      t.string :name, null: false
      t.integer :service_price_variations_ids, array: true
      t.integer :priority, null: false
      t.string :application, null: false

      t.timestamps
    end
  end
end
