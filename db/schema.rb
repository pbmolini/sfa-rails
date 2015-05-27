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

ActiveRecord::Schema.define(version: 20150527212018) do

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

  create_table "boat_features_sets", force: :cascade do |t|
    t.integer  "boat_id"
    t.boolean  "outboard_engine",             default: false
    t.boolean  "inboard_engine",              default: false
    t.boolean  "vhf",                         default: false
    t.boolean  "depth_finder",                default: false
    t.boolean  "speed_instrumentation_radar", default: false
    t.boolean  "sonar",                       default: false
    t.boolean  "autopilot",                   default: false
    t.boolean  "anchor",                      default: false
    t.boolean  "anchor_windlass",             default: false
    t.boolean  "boarding_ladder",             default: false
    t.boolean  "shower",                      default: false
    t.boolean  "wc",                          default: false
    t.boolean  "radio_stereo_cd_mp3",         default: false
    t.boolean  "tv",                          default: false
    t.boolean  "cabin_cruiser_bed",           default: false
    t.boolean  "galley",                      default: false
    t.boolean  "sink",                        default: false
    t.boolean  "cooler",                      default: false
    t.boolean  "liferaft",                    default: false
    t.boolean  "trolling_motor",              default: false
    t.boolean  "bimini_top",                  default: false
    t.boolean  "sunbathing_area",             default: false
    t.boolean  "sport_fishing_equipment",     default: false
    t.boolean  "safety_equipment",            default: false
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  add_index "boat_features_sets", ["anchor"], name: "index_boat_features_sets_on_anchor"
  add_index "boat_features_sets", ["anchor_windlass"], name: "index_boat_features_sets_on_anchor_windlass"
  add_index "boat_features_sets", ["autopilot"], name: "index_boat_features_sets_on_autopilot"
  add_index "boat_features_sets", ["bimini_top"], name: "index_boat_features_sets_on_bimini_top"
  add_index "boat_features_sets", ["boarding_ladder"], name: "index_boat_features_sets_on_boarding_ladder"
  add_index "boat_features_sets", ["boat_id"], name: "index_boat_features_sets_on_boat_id"
  add_index "boat_features_sets", ["cabin_cruiser_bed"], name: "index_boat_features_sets_on_cabin_cruiser_bed"
  add_index "boat_features_sets", ["cooler"], name: "index_boat_features_sets_on_cooler"
  add_index "boat_features_sets", ["depth_finder"], name: "index_boat_features_sets_on_depth_finder"
  add_index "boat_features_sets", ["galley"], name: "index_boat_features_sets_on_galley"
  add_index "boat_features_sets", ["inboard_engine"], name: "index_boat_features_sets_on_inboard_engine"
  add_index "boat_features_sets", ["liferaft"], name: "index_boat_features_sets_on_liferaft"
  add_index "boat_features_sets", ["outboard_engine"], name: "index_boat_features_sets_on_outboard_engine"
  add_index "boat_features_sets", ["radio_stereo_cd_mp3"], name: "index_boat_features_sets_on_radio_stereo_cd_mp3"
  add_index "boat_features_sets", ["safety_equipment"], name: "index_boat_features_sets_on_safety_equipment"
  add_index "boat_features_sets", ["shower"], name: "index_boat_features_sets_on_shower"
  add_index "boat_features_sets", ["sink"], name: "index_boat_features_sets_on_sink"
  add_index "boat_features_sets", ["sonar"], name: "index_boat_features_sets_on_sonar"
  add_index "boat_features_sets", ["speed_instrumentation_radar"], name: "index_boat_features_sets_on_speed_instrumentation_radar"
  add_index "boat_features_sets", ["sport_fishing_equipment"], name: "index_boat_features_sets_on_sport_fishing_equipment"
  add_index "boat_features_sets", ["sunbathing_area"], name: "index_boat_features_sets_on_sunbathing_area"
  add_index "boat_features_sets", ["trolling_motor"], name: "index_boat_features_sets_on_trolling_motor"
  add_index "boat_features_sets", ["tv"], name: "index_boat_features_sets_on_tv"
  add_index "boat_features_sets", ["vhf"], name: "index_boat_features_sets_on_vhf"
  add_index "boat_features_sets", ["wc"], name: "index_boat_features_sets_on_wc"

  create_table "boats", force: :cascade do |t|
    t.string   "name"
    t.string   "manufacturer"
    t.integer  "daily_price"
    t.integer  "year"
    t.string   "model"
    t.decimal  "length",           precision: 8, scale: 2
    t.integer  "guest_capacity"
    t.integer  "boat_category_id"
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
    t.integer  "user_id"
    t.text     "description"
    t.string   "fuel_type"
    t.boolean  "with_license",                             default: false
    t.string   "rental_type"
    t.string   "address"
    t.integer  "horse_power"
    t.boolean  "complete",                                 default: false
    t.float    "latitude"
    t.float    "longitude"
  end

  add_index "boats", ["boat_category_id"], name: "index_boats_on_boat_category_id"
  add_index "boats", ["user_id"], name: "index_boats_on_user_id"

  create_table "bookings", force: :cascade do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "people_on_board"
    t.integer  "boat_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "user_id"
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

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                  default: false
    t.string   "provider"
    t.string   "uid"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "location"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.text     "bio"
    t.string   "phone"
    t.date     "birthdate"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
