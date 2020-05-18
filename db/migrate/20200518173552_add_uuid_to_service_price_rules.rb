class AddUuidToServicePriceRules < ActiveRecord::Migration[6.0]
  def change
    add_column :service_price_rules, :uuid, :uuid, default: 'uuid_generate_v4()', null: false

    add_index :service_price_rules, :uuid, unique: true

    remove_foreign_key :service_price_variations, :service_price_rules
    remove_foreign_key :service_price_combinations, :service_price_rules

    execute <<-SQL
      ALTER TABLE service_price_variations ALTER COLUMN service_price_rule_id SET DATA TYPE UUID USING (uuid_generate_v4());
      ALTER TABLE service_price_combinations ALTER COLUMN service_price_rule_id SET DATA TYPE UUID USING (uuid_generate_v4());

      UPDATE service_price_variations
        SET service_price_rule_id = service_price_rules.uuid
        FROM service_price_rules
        WHERE service_price_variations.service_price_rule_id = service_price_rules.uuid;

      UPDATE service_price_combinations
        SET service_price_rule_id = service_price_rules.uuid
        FROM service_price_rules
        WHERE service_price_combinations.service_price_rule_id = service_price_rules.uuid;

      ALTER TABLE service_price_rules DROP CONSTRAINT service_price_rules_pkey;
      ALTER INDEX index_service_price_rules_on_uuid RENAME TO service_price_rules_pkey;
      ALTER TABLE service_price_rules ADD PRIMARY KEY USING INDEX service_price_rules_pkey;
    SQL

    remove_column :service_price_rules, :id
    rename_column :service_price_rules, :uuid, :id

    add_foreign_key :service_price_variations, :service_price_rules
  end
end
