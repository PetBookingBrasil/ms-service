class AddParentIdToServiceCategories < ActiveRecord::Migration[6.0]
  def change
    add_column :service_categories, :parent_id, :integer
  end
end
