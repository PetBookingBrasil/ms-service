class AddAncestryReferencesOnServiceCategories < ActiveRecord::Migration[6.0]
  def change
    add_foreign_key :service_categories, :service_categories, column: :ancestry_id, primary_key: "id"
  end
end
