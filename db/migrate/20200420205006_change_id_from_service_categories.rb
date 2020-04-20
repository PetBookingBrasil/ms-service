class ChangeIdFromServiceCategories < ActiveRecord::Migration[6.0]
  def up

    remove_column :service_categories, :uuid
    rename_column :service_categories, :id, :uuid
    remove_column :service_categories, :system_code
    add_column :service_categories, :system_code, :integer
    execute('create sequence IF NOT EXISTS service_categories_system_code increment 1 start 100000')
    execute("ALTER TABLE service_categories ALTER COLUMN system_code SET DEFAULT nextval('service_categories_system_code')")
  end

  def down
    execute("ALTER TABLE service_categories ALTER COLUMN system_code type varchar(200)")
    rename_column :service_categories, :uuid, :id
    add_column :service_categories, :uuid, :string
  end
end
