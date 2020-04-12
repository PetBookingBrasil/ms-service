# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_04_12_142802) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "service_categories", force: :cascade do |t|
    t.string "uuid"
    t.string "name"
    t.string "slug"
    t.string "system_code"
    t.integer "business_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "parent_id"
    t.string "ancestry"
    t.index ["ancestry"], name: "index_service_categories_on_ancestry"
  end

# Could not dump table "services" because of following StandardError
#   Unknown type 'valid_applications' for column 'validations'

end
