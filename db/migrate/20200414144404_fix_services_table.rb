class FixServicesTable < ActiveRecord::Migration[6.0]
  def up
    remove_column :services, :validations
  end

  def down
    add_column :services, :validations, :string
  end
end
