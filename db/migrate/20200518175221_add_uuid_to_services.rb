class AddUuidToServices < ActiveRecord::Migration[6.0]
  def change
    remove_column :services, :uuid

    add_column :services, :uuid, :uuid, default: 'uuid_generate_v4()', null: false

    add_index :services, :uuid, unique: true

    execute <<-SQL
      ALTER TABLE services DROP CONSTRAINT services_pkey;
      ALTER INDEX index_services_on_uuid RENAME TO services_pkey;
      ALTER TABLE services ADD PRIMARY KEY USING INDEX services_pkey;
    SQL


    remove_column :services, :id
    rename_column :services, :uuid, :id
  end
end
