class AddUuidToServiceIdFromBusinessServices < ActiveRecord::Migration[6.0]
  def change
      execute <<-SQL
      ALTER TABLE business_services ALTER COLUMN service_id SET DATA TYPE UUID USING (uuid_generate_v4());

      UPDATE business_services
        SET service_id = services.id
        FROM services
        WHERE business_services.service_id = services.id;
      SQL

      add_foreign_key :business_services, :services
  end
end
