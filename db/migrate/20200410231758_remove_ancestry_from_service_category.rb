class RemoveAncestryFromServiceCategory < ActiveRecord::Migration[6.0]
  def up
    remove_column :service_categories, :ancestry_id
  end

  def down
    add_column :service_categories, :ancestry_id, :integer
  end
end
