class AddAncestryToServices < ActiveRecord::Migration[6.0]
  def change
    add_column :services, :ancestry, :string
    add_index :services, :ancestry
  end
end
