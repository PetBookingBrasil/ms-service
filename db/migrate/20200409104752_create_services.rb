class CreateServices < ActiveRecord::Migration[6.0]
  def up
    create_table :services do |t|
      t.string :uuid
      t.string :name
      t.string :slug
      t.string :validations
      t.boolean :public
      t.references :service_category

      t.timestamps
    end
  end
  

  def down 
    drop_table :services
  end
end
