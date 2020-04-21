class ChangeBusinessServicePrices < ActiveRecord::Migration[6.0]
  def change
    change_column :business_service_prices, :business_service_id, :integer, null: true
  end
end
