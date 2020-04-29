class DropTableServiceCategoryHierarchies < ActiveRecord::Migration[6.0]
  def change
    drop_table :service_category_hierarchies
    
  end
end
