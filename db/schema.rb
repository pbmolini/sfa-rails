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

ActiveRecord::Schema.define(version: 20150110183352) do

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
    t.integer  "length"
    t.integer  "guest_capacity"
    t.integer  "boat_category_id"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "boats", ["boat_category_id"], name: "index_boats_on_boat_category_id"

end
