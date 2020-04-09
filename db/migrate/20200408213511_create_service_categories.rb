class CreateServiceCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :service_categories do |t|
      t.string :uuid
      t.string :name
      t.string :slug
      t.string :system_code
      t.integer :business_id
      t.integer :ancestry_id

      t.timestamps
    end
  end
end
