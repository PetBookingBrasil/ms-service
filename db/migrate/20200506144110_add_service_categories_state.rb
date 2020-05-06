class AddServiceCategoriesState < ActiveRecord::Migration[6.0]
  def self.up
    add_column :service_categories, :aasm_state, :integer
  end

  def self.down
    remove_column :service_categories, :aasm_state
  end
end
