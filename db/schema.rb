# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171018120640) do

  create_table "discounts", force: :cascade do |t|
    t.string "name"
    t.integer "value"
  end

  create_table "loyalty_cards", force: :cascade do |t|
    t.integer "user_id"
    t.integer "discount"
  end

  create_table "order_discounts", force: :cascade do |t|
    t.integer "order_id"
    t.integer "discount_id"
  end

  create_table "order_lines", force: :cascade do |t|
    t.integer "order_id"
    t.integer "product_id"
    t.integer "quantity"
    t.index ["order_id", "product_id"], name: "index_order_lines_on_order_id_and_product_id"
  end

  create_table "order_processes", force: :cascade do |t|
    t.string "order_uuid", null: false
    t.boolean "completed"
    t.string "state"
    t.index ["order_uuid"], name: "index_order_processes_on_order_uuid", unique: true
  end

  create_table "orders", force: :cascade do |t|
    t.string "uuid"
    t.string "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "uuid"
    t.string "name"
    t.integer "quantity"
    t.integer "price"
  end

  create_table "r.baskets", force: :cascade do |t|
    t.integer "order_id"
    t.string "products"
    t.integer "discount"
    t.integer "total_price"
  end

  create_table "users", force: :cascade do |t|
    t.string "uuid"
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "write_repo", force: :cascade do |t|
    t.string "aggregate_type"
    t.string "aggregate_uuid"
    t.string "event_name"
    t.string "data"
    t.datetime "created_at"
  end

end
