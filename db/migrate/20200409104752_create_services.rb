class CreateServices < ActiveRecord::Migration[6.0]
  def up
    execute("CREATE TYPE valid_applications AS ENUM ('varejopet', 'petbooking', 'amei')")

    create_table :services do |t|
      t.string :uuid
      t.string :name
      t.string :slug
      t.boolean :public
      t.references :service_category

      t.timestamps
    end
    execute("alter table services add column validations valid_applications")
  end
  

  def down 
    drop_table :services
    execute("drop type valid_applications")
    
  end
end
