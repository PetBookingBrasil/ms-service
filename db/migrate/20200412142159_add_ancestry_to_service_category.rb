class AddAncestryToServiceCategory < ActiveRecord::Migration[6.0]
  def change
    add_column :service_categories, :ancestry, :string
    add_index :service_categories, :ancestry
  end
end
