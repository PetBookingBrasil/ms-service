class AddColumnsToServices < ActiveRecord::Migration[6.0]
  def change
    add_column :services, :duration, :integer, default: 0
    add_column :services, :reschedule_reminder_days_after, :integer, default: 0
    add_column :services, :comission_percentage, :float, default: 0.0
    add_column :services, :price, :decimal, precision: 8, scale: 2, default: 0.0, null: false
    add_column :services, :reschedule_reminder_message, :string, default: "",  null: false
    add_column :services, :description, :string, default: "",  null: false
    add_column :services, :bitmask, :integer, default: 9,   null: false
    add_column :services, :aasm_state, :integer, default: 1,   null: false
    add_column :services, :service_template_id, :uuid
    add_column :services, :pet_prices, :jsonb
    add_column :services, :municipal_code, :string
    add_column :services, :aliquot, :float, default: 0.0
    add_column :services, :iss_type, :integer, default: 0
    add_column :services, :events_number, :integer, default: 1,   null: false
  end
end
