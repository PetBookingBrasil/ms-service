class CreateServicePriceVariations < ActiveRecord::Migration[6.0]
  def change
    create_table :service_price_variations do |t|
      t.string :name, null: false
      t.text :variations, array: true
      t.integer :priority, null: false
      t.string :kind, null: false

      t.timestamps
    end
  end
end
