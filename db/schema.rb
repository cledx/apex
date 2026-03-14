# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_03_15_120000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "houses", force: :cascade do |t|
    t.string "address", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.date "end_date", null: false
    t.string "name"
    t.string "owner", null: false
    t.date "start_date", null: false
    t.string "tags", default: [], array: true
    t.datetime "updated_at", null: false
  end

  create_table "items", force: :cascade do |t|
    t.string "age"
    t.string "category"
    t.string "condition"
    t.datetime "created_at", null: false
    t.text "description"
    t.bigint "house_id", null: false
    t.string "name"
    t.string "price"
    t.string "tags", default: [], array: true
    t.datetime "updated_at", null: false
    t.index ["category"], name: "index_items_on_category"
    t.index ["house_id"], name: "index_items_on_house_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.string "role", default: "customer", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "want_to_buys", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "item_id", null: false
    t.text "notes"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["item_id"], name: "index_want_to_buys_on_item_id"
    t.index ["user_id"], name: "index_want_to_buys_on_user_id"
  end

  add_foreign_key "items", "houses"
  add_foreign_key "want_to_buys", "items"
  add_foreign_key "want_to_buys", "users"
end
