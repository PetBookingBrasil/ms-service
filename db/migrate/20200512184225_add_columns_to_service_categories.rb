class AddColumnsToServiceCategories < ActiveRecord::Migration[6.0]
  def up
    add_column :service_categories, :starts_at, :datetime
    add_column :service_categories, :ends_at, :datetime
  end

  def down
    remove_column :service_categories, :starts_at
    remove_column :service_categories, :ends_at
  end
end
