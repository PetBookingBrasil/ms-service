class AddColumnApplicationToServiceCategories < ActiveRecord::Migration[6.0]
  def change
    add_column :service_categories, :application, :string
  end
end
