class FixServicesTable < ActiveRecord::Migration[6.0]
  def up
    add_column :services, :application, :string
    add_column :services, :business_id, :integer
    remove_column :services, :validations
    remove_column :services, :public
  end

  def down
    remove_column :services, :application
    remove_column :services, :business_id
    add_column :services, :public, :boolean
    add_column :services, :validations, :string
  end
end
