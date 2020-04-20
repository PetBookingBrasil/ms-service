class CreateSequenceToServicePriceCombinations < ActiveRecord::Migration[6.0]
  def change
    change_column :service_price_combinations, :system_code, :integer

    execute <<-SQL
      CREATE SEQUENCE system_code_seq START WITH 100000;
      ALTER TABLE service_price_combinations ALTER COLUMN system_code SET DEFAULT nextval('system_code_seq');
    SQL
  end
end
