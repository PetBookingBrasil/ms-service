class CreateBusinessServices < ActiveRecord::Migration[6.0]
  def change
    create_table :business_services do |t|
      t.references :service
      t.integer :business_id, null: false
      t.float :comission_percentage
      t.time :duration
      t.float :cost
      t.timestamps
    end
  end
end
