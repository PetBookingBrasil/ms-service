class AddUuidToServicePriceVariations < ActiveRecord::Migration[6.0]
  def change
    add_column :service_price_variations, :uuid, :uuid, default: 'uuid_generate_v4()', null: false

    add_index :service_price_variations, :uuid, unique: true

    execute <<-SQL
      ALTER TABLE service_price_variations DROP CONSTRAINT service_price_variations_pkey;
      ALTER INDEX index_service_price_variations_on_uuid RENAME TO service_price_variations_pkey;
      ALTER TABLE service_price_variations ADD PRIMARY KEY USING INDEX service_price_variations_pkey;
    SQL

    remove_column :service_price_variations, :id
    rename_column :service_price_variations, :uuid, :id
  end
end
