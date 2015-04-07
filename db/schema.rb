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

end
