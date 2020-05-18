class AddUuidToServiceCategories < ActiveRecord::Migration[6.0]
  def change
    rename_column :service_categories, :uuid, :old_uuid
    rename_column :services, :service_category_id, :old_service_category_id

    add_column :service_categories, :uuid, :uuid, default: 'uuid_generate_v4()', null: false
    add_column :services, :service_category_id, :uuid

    change_column :service_categories, :parent_id, :string

    add_index :service_categories, :uuid, unique: true

    execute <<-SQL

      UPDATE services
        SET service_category_id = service_categories.uuid
        FROM service_categories
        WHERE services.old_service_category_id = service_categories.old_uuid;

      ALTER TABLE service_categories DROP CONSTRAINT service_categories_pkey;
      ALTER INDEX index_service_categories_on_uuid RENAME TO service_categories_pkey;
      ALTER TABLE service_categories ADD PRIMARY KEY USING INDEX service_categories_pkey;
    SQL

    rename_column :service_categories, :uuid, :id
    remove_column :service_categories, :old_uuid
    remove_column :services, :old_service_category_id

    add_foreign_key :services, :service_categories
  end
end
