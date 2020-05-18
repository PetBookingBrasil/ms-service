class AddUuidToBusinessServices < ActiveRecord::Migration[6.0]
  def change
    enable_extension 'uuid-ossp'

    add_column :business_services, :uuid, :uuid, default: 'uuid_generate_v4()', null: false

    add_index :business_services, :uuid, unique: true

    execute <<-SQL
      ALTER TABLE business_service_prices ALTER COLUMN business_service_id SET DATA TYPE UUID USING (uuid_generate_v4());

      UPDATE business_service_prices
        SET business_service_id = business_services.uuid
        FROM business_services
        WHERE business_service_prices.business_service_id = business_services.uuid;

      ALTER TABLE business_services DROP CONSTRAINT business_services_pkey;
      ALTER INDEX index_business_services_on_uuid RENAME TO business_services_pkey;
      ALTER TABLE business_services ADD PRIMARY KEY USING INDEX business_services_pkey;
    SQL

    remove_column :business_services, :id
    rename_column :business_services, :uuid, :id

    add_foreign_key :business_service_prices, :business_services
  end
end
