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

ActiveRecord::Schema.define(version: 2020_04_16_140646) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "business_service_prices", force: :cascade do |t|
    t.bigint "business_service_id", null: false
    t.bigint "service_price_combination_id", null: false
    t.decimal "price", precision: 10, scale: 2
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["business_service_id"], name: "index_business_service_prices_on_business_service_id"
    t.index ["service_price_combination_id"], name: "index_business_service_prices_on_service_price_combination_id"
  end

  create_table "service_categories", force: :cascade do |t|
    t.string "uuid"
    t.string "name"
    t.string "slug"
    t.string "system_code"
    t.integer "business_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "parent_id"
  end

  create_table "service_category_hierarchies", id: false, force: :cascade do |t|
    t.integer "ancestor_id", null: false
    t.integer "descendant_id", null: false
    t.integer "generations", null: false
    t.index ["ancestor_id", "descendant_id", "generations"], name: "service_category_anc_desc_idx", unique: true
    t.index ["descendant_id"], name: "service_category_desc_idx"
  end

  create_table "service_price_combinations", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "service_price_rule_id", null: false
    t.bigint "system_code", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "slug"
    t.index ["service_price_rule_id"], name: "index_service_price_combinations_on_service_price_rule_id"
    t.index ["system_code"], name: "index_service_price_combinations_on_system_code"
  end

  create_table "service_price_rules", force: :cascade do |t|
    t.string "name", null: false
    t.integer "service_price_variations_ids", array: true
    t.integer "priority", null: false
    t.string "application", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "service_price_variations", force: :cascade do |t|
    t.string "name", null: false
    t.text "variations", array: true
    t.integer "priority", null: false
    t.string "kind", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

# Could not dump table "services" because of following StandardError
#   Unknown type 'valid_applications' for column 'validations'

  add_foreign_key "business_service_prices", "service_price_combinations"
  add_foreign_key "service_price_combinations", "service_price_rules"
end
