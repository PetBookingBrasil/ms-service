class CreateServicePriceCombinations < ActiveRecord::Migration[6.0]
  def change
    create_table :service_price_combinations do |t|
      t.string :name, null: false
      t.references :service_price_rule, null: false, foreign_key: true
      t.bigint :system_code, null: false, unique: true, index: true

      t.timestamps
    end
  end
end
