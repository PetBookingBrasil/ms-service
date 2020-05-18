class AddUuidToBusinessServicePrices < ActiveRecord::Migration[6.0]
  def change
    add_column :business_service_prices, :uuid, :uuid, default: 'uuid_generate_v4()', null: false

    add_index :business_service_prices, :uuid, unique: true

    execute <<-SQL
      ALTER TABLE business_service_prices DROP CONSTRAINT business_service_prices_pkey;
      ALTER INDEX index_business_service_prices_on_uuid RENAME TO business_service_prices_pkey;
      ALTER TABLE business_service_prices ADD PRIMARY KEY USING INDEX business_service_prices_pkey;
    SQL

    remove_column :business_service_prices, :id
    rename_column :business_service_prices, :uuid, :id
  end
end
