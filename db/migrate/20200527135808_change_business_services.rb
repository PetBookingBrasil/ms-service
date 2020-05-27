class ChangeBusinessServices < ActiveRecord::Migration[6.0]
  def change
    add_column :business_services, :franchisor_id, :integer

    change_column :business_services, :cost, :decimal, precision: 8, scale: 2, default: 0

    remove_column :business_services, :duration

    add_column :business_services, :duration, :integer, default: 0
  end
end
