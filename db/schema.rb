# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150219202512) do

  create_table "boat_categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "boat_features", force: :cascade do |t|
    t.string   "name"
    t.integer  "boat_category_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "boat_features", ["boat_category_id"], name: "index_boat_features_on_boat_category_id"

  create_table "boats", force: :cascade do |t|
    t.string   "name"
    t.string   "manufacturer"
    t.decimal  "daily_price",      precision: 8, scale: 2
    t.integer  "year"
    t.string   "model"
    t.decimal  "length",           precision: 8, scale: 2
    t.integer  "guest_capacity"
    t.integer  "boat_category_id"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "boats", ["boat_category_id"], name: "index_boats_on_boat_category_id"

  create_table "bookings", force: :cascade do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "people_on_board"
    t.integer  "boat_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "bookings", ["boat_id"], name: "index_bookings_on_boat_id"

  create_table "pictures", force: :cascade do |t|
    t.integer  "boat_id"
    t.string   "description"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "pictures", ["boat_id"], name: "index_pictures_on_boat_id"

end
