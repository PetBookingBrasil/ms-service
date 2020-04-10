class CreateServiceCategoryHierarchies < ActiveRecord::Migration[6.0]
  def change
    create_table :service_category_hierarchies, id: false do |t|
      t.integer :ancestor_id, null: false
      t.integer :descendant_id, null: false
      t.integer :generations, null: false
    end

    add_index :service_category_hierarchies, [:ancestor_id, :descendant_id, :generations],
      unique: true,
      name: "service_category_anc_desc_idx"

    add_index :service_category_hierarchies, [:descendant_id],
      name: "service_category_desc_idx"
  end
end
