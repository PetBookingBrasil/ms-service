class AddSlugToServicePriceCombinations < ActiveRecord::Migration[6.0]
  def change
    add_column :service_price_combinations, :slug, :string, unique: true, index: true
  end
end
