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

<<<<<<< HEAD
ActiveRecord::Schema.define(version: 20141206221925) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_keys", force: true do |t|
    t.string   "access_token"
    t.string   "user_id"
    t.string   "expires_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

# Could not dump table "choices" because of following StandardError
#   Unknown type 'name' for column 'first_event'

  create_table "events", force: true do |t|
    t.string   "name"
    t.string   "price"
    t.string   "location"
    t.string   "dayOn"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "url"
    t.string   "categoryList", default: [], array: true
    t.string   "dayEnd"
    t.text     "desc"
    t.string   "image"
    t.string   "source"
  end

  create_table "users", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
  end

=======
ActiveRecord::Schema.define(version: 20150407041517) do

  create_table "images", force: true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "comic_file_name"
    t.string   "comic_content_type"
    t.integer  "comic_file_size"
    t.datetime "comic_updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",            null: false
    t.string   "crypted_password", null: false
    t.string   "salt",             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

>>>>>>> 6721de769c2e5cfebde11d8b6c385461dda1287d
end
