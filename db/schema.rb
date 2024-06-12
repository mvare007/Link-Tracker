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

ActiveRecord::Schema[7.0].define(version: 2024_06_12_152214) do
  create_table "clients", force: :cascade do |t|
    t.string "name", null: false
    t.string "store_url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_url"], name: "index_clients_on_store_url", unique: true
  end

  create_table "tracking_links", force: :cascade do |t|
    t.string "tracking_code", null: false
    t.integer "client_id", null: false
    t.string "target_url", null: false
    t.integer "visits_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_tracking_links_on_client_id"
    t.index ["tracking_code", "client_id"], name: "index_tracking_links_on_tracking_code_and_client_id", unique: true
    t.index ["tracking_code"], name: "index_tracking_links_on_tracking_code"
  end

  create_table "visits", force: :cascade do |t|
    t.integer "tracking_link_id", null: false
    t.string "ip_address", null: false
    t.string "user_agent", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tracking_link_id"], name: "index_visits_on_tracking_link_id"
  end

  add_foreign_key "tracking_links", "clients"
  add_foreign_key "visits", "tracking_links"
end
