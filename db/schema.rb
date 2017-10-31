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

ActiveRecord::Schema.define(version: 20171031084557) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "members", force: :cascade do |t|
    t.string   "login"
    t.string   "name"
    t.string   "idno"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.string   "source"
    t.string   "service"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "user_name",      limit: 64,  default: "", null: false
    t.string   "provider",                   default: "", null: false
    t.string   "uid",                        default: "", null: false
    t.string   "oauth_token",                default: "", null: false
    t.string   "email",          limit: 128, default: "", null: false
    t.string   "user_full_name", limit: 64,  default: "", null: false
    t.integer  "university_id",  limit: 2,   default: 1,  null: false
    t.string   "slack_user",     limit: 64,  default: "", null: false
    t.string   "student_no",     limit: 64,  default: "", null: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true, using: :btree
    t.index ["slack_user"], name: "index_users_on_slack_user", unique: true, using: :btree
    t.index ["university_id", "student_no"], name: "index_users_on_university_id_and_student_no", unique: true, using: :btree
    t.index ["user_name"], name: "index_users_on_user_name", unique: true, using: :btree
  end

end
