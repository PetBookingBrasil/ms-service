class AddDeletedAtToServiceCategories < ActiveRecord::Migration[6.0]
  def change
    add_column :service_categories, :deleted_at, :datetime
  end
end
