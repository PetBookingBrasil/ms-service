class CreateBusinessServicePrices < ActiveRecord::Migration[6.0]
  def change
    create_table :business_service_prices do |t|
      t.references :business_service, null: false
      t.references :service_price_combination, null: false, foreign_key: true
      t.decimal :price, precision: 10, scale: 2

      t.timestamps
    end
  end
end
