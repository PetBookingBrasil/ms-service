class AddUuidToServicePriceCombinations < ActiveRecord::Migration[6.0]
  def change
    add_column :service_price_combinations, :uuid, :uuid, default: 'uuid_generate_v4()', null: false

    add_index :service_price_combinations, :uuid, unique: true

    remove_foreign_key :business_service_prices, :service_price_combinations

    execute <<-SQL
      ALTER TABLE business_service_prices ALTER COLUMN service_price_combination_id SET DATA TYPE UUID USING (uuid_generate_v4());

      UPDATE business_service_prices
        SET service_price_combination_id = service_price_combinations.uuid
        FROM service_price_combinations
        WHERE business_service_prices.service_price_combination_id = service_price_combinations.uuid;

      ALTER TABLE service_price_combinations DROP CONSTRAINT service_price_combinations_pkey;
      ALTER INDEX index_service_price_combinations_on_uuid RENAME TO service_price_combinations_pkey;
      ALTER TABLE service_price_combinations ADD PRIMARY KEY USING INDEX service_price_combinations_pkey;
    SQL

    remove_column :service_price_combinations, :id
    rename_column :service_price_combinations, :uuid, :id

    add_foreign_key :business_service_prices, :service_price_combinations
  end
end
