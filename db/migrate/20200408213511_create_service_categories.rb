class CreateServiceCategories < ActiveRecord::Migration[6.0]
  def up
    create_table :service_categories, id: false do |t|
      t.integer :uuid, primary_key: true
      t.string :name
      t.string :slug
      t.integer :system_code
      t.integer :business_id
      t.integer :ancestry_id

      t.timestamps
    end

    execute('create sequence IF NOT EXISTS service_categories_system_code_seq increment 1 start 100000')
    # execute("ALTER TABLE service_categories ALTER COLUMN uuid SET DEFAULT nextval('service_categories_id_seq')")
    execute("ALTER TABLE service_categories ALTER COLUMN system_code SET DEFAULT nextval('service_categories_system_code_seq')")
  end

  def down
    execute("ALTER TABLE service_categories ALTER COLUMN system_code type varchar(200)")
    execute("ALTER TABLE service_categories ALTER COLUMN uuid SET DEFAULT ''")
  end
end
