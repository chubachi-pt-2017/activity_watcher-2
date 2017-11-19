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

ActiveRecord::Schema.define(version: 20171119053049) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "course_participants", force: :cascade do |t|
    t.integer  "course_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id", "user_id"], name: "index_course_participants_on_course_id_and_user_id", unique: true, using: :btree
    t.index ["course_id"], name: "index_course_participants_on_course_id", using: :btree
    t.index ["user_id"], name: "index_course_participants_on_user_id", using: :btree
  end

  create_table "courses", force: :cascade do |t|
    t.string   "title",               limit: 128, default: "", null: false
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.datetime "student_entry_start",                          null: false
    t.datetime "student_entry_end",                            null: false
    t.string   "description",         limit: 256
    t.integer  "owner_id"
    t.integer  "university_id"
    t.index ["owner_id"], name: "index_courses_on_owner_id", using: :btree
    t.index ["title"], name: "index_courses_on_title", unique: true, using: :btree
    t.index ["university_id"], name: "index_courses_on_university_id", using: :btree
  end

  create_table "task_teams", force: :cascade do |t|
    t.integer  "task_id"
    t.integer  "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["task_id", "team_id"], name: "index_task_teams_on_task_id_and_team_id", unique: true, using: :btree
    t.index ["task_id"], name: "index_task_teams_on_task_id", using: :btree
    t.index ["team_id"], name: "index_task_teams_on_team_id", using: :btree
  end

  create_table "tasks", force: :cascade do |t|
    t.string   "title",        limit: 128, default: "", null: false
    t.datetime "start_date",                            null: false
    t.datetime "end_date",                              null: false
    t.string   "description",  limit: 256
    t.string   "slack_domain", limit: 128, default: "", null: false
    t.integer  "course_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.index ["course_id"], name: "index_tasks_on_course_id", using: :btree
    t.index ["slack_domain"], name: "index_tasks_on_slack_domain", unique: true, using: :btree
    t.index ["title"], name: "index_tasks_on_title", unique: true, using: :btree
  end

  create_table "team_participants", force: :cascade do |t|
    t.integer  "team_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id", "user_id"], name: "index_team_participants_on_team_id_and_user_id", unique: true, using: :btree
    t.index ["team_id"], name: "index_team_participants_on_team_id", using: :btree
    t.index ["user_id"], name: "index_team_participants_on_user_id", using: :btree
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name",            limit: 64,  default: "", null: false
    t.string   "description",     limit: 256
    t.string   "repository_name", limit: 128, default: "", null: false
    t.string   "service_url",     limit: 256
    t.string   "ci_url",          limit: 256
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.index ["name"], name: "index_teams_on_name", unique: true, using: :btree
    t.index ["repository_name"], name: "index_teams_on_repository_name", unique: true, using: :btree
  end

  create_table "universities", force: :cascade do |t|
    t.string   "name",         limit: 64,  default: "", null: false
    t.string   "name_en",      limit: 128, default: "", null: false
    t.string   "description",  limit: 256
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "email_domain", limit: 64,  default: "", null: false
  end

  create_table "user_universities", force: :cascade do |t|
    t.string   "confirmation_token",  limit: 256,                 null: false
    t.string   "email",               limit: 128,                 null: false
    t.string   "student_no",          limit: 64
    t.boolean  "email_confirmed_flg",             default: false, null: false
    t.integer  "user_id"
    t.integer  "university_id"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.index ["confirmation_token"], name: "index_user_universities_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_user_universities_on_email", unique: true, using: :btree
    t.index ["university_id"], name: "index_user_universities_on_university_id", using: :btree
    t.index ["user_id", "university_id"], name: "index_user_universities_on_user_id_and_university_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_user_universities_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "login_name",                 limit: 64, default: "",    null: false
    t.string   "login_provider",                        default: "",    null: false
    t.string   "uid",                                   default: "",    null: false
    t.string   "oauth_token",                           default: "",    null: false
    t.string   "user_full_name",             limit: 64, default: "",    null: false
    t.string   "slack_user",                 limit: 64, default: "",    null: false
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.integer  "authority",                  limit: 2,  default: 1,     null: false
    t.boolean  "registration_confirmed_flg",            default: false, null: false
    t.index ["login_name"], name: "index_users_on_login_name", unique: true, using: :btree
    t.index ["login_provider", "uid"], name: "index_users_on_login_provider_and_uid", unique: true, using: :btree
    t.index ["slack_user"], name: "index_users_on_slack_user", using: :btree
  end

  add_foreign_key "course_participants", "courses"
  add_foreign_key "course_participants", "users"
  add_foreign_key "courses", "universities"
  add_foreign_key "courses", "users", column: "owner_id"
  add_foreign_key "task_teams", "tasks"
  add_foreign_key "task_teams", "teams"
  add_foreign_key "tasks", "courses"
  add_foreign_key "team_participants", "teams"
  add_foreign_key "team_participants", "users"
  add_foreign_key "user_universities", "universities"
  add_foreign_key "user_universities", "users"
end
