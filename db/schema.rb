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

ActiveRecord::Schema.define(version: 20150607144430) do

  create_table "challenges", force: true do |t|
    t.integer  "route_id",     null: false
    t.date     "finish_date",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "start_point",  null: false
    t.integer  "finish_point", null: false
  end

  create_table "challenges_users", id: false, force: true do |t|
    t.integer "user_id",      null: false
    t.integer "challenge_id", null: false
  end

  add_index "challenges_users", ["challenge_id"], name: "index_challenges_users_on_challenge_id", using: :btree
  add_index "challenges_users", ["user_id"], name: "index_challenges_users_on_user_id", using: :btree

  create_table "check_points", force: true do |t|
    t.decimal  "longitude",                   precision: 23, scale: 20, null: false
    t.decimal  "latitude",                    precision: 23, scale: 20, null: false
    t.integer  "trip_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rpm",                                                   null: false
    t.integer  "speed",                                                 null: false
    t.float    "fuel_consumption", limit: 24,                           null: false
    t.integer  "gear",                                                  null: false
    t.float    "recorded_at",      limit: 24,                           null: false
  end

  create_table "engine_displacements", force: true do |t|
    t.string "disp"
  end

  create_table "engine_types", force: true do |t|
    t.string  "eng_type"
    t.integer "gear_up_min"
    t.integer "gear_up_max"
    t.integer "gear_down"
  end

  create_table "fuel_consumptions", force: true do |t|
    t.integer  "engine_displacement_id",            null: false
    t.integer  "engine_type_id",                    null: false
    t.float    "low",                    limit: 24, null: false
    t.float    "high",                   limit: 24, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invitations", force: true do |t|
    t.integer  "invited_by_id", null: false
    t.integer  "user_id",       null: false
    t.integer  "challenge_id",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trips", force: true do |t|
    t.float    "distance",               limit: 24,                         null: false
    t.float    "avg_rpm",                limit: 24,                         null: false
    t.float    "avg_fuel",               limit: 24,                         null: false
    t.datetime "date",                                                      null: false
    t.integer  "user_id"
    t.integer  "avg_speed",                                                 null: false
    t.string   "beginning",                                                 null: false
    t.string   "finish",                                                    null: false
    t.integer  "challenge_id"
    t.integer  "engine_type_id"
    t.integer  "engine_displacement_id"
    t.decimal  "mark",                              precision: 4, scale: 2
  end

  add_index "trips", ["challenge_id"], name: "index_trips_on_challenge_id", using: :btree
  add_index "trips", ["engine_displacement_id"], name: "index_trips_on_engine_displacement_id", using: :btree
  add_index "trips", ["engine_type_id"], name: "index_trips_on_engine_type_id", using: :btree
  add_index "trips", ["user_id"], name: "index_trips_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.integer  "engine_type_id"
    t.integer  "engine_displacement_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["engine_displacement_id"], name: "index_users_on_engine_displacement_id", using: :btree
  add_index "users", ["engine_type_id"], name: "index_users_on_engine_type_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
