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

ActiveRecord::Schema.define(version: 20150508031423) do

  create_table "images", force: true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "comic_file_name"
    t.string   "comic_content_type"
    t.integer  "comic_file_size"
    t.datetime "comic_updated_at"
    t.integer  "order"
    t.boolean  "published",          default: false
    t.string   "title"
    t.boolean  "show_title",         default: false
    t.boolean  "large_img",          default: false
  end

  create_table "subscribers", force: true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "subscribed", default: true
    t.boolean  "intro_sent", default: true
  end

  create_table "users", force: true do |t|
    t.string   "email",            null: false
    t.string   "crypted_password", null: false
    t.string   "salt",             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "phone_number"
    t.string   "country_code"
    t.string   "authy_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
