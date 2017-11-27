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

ActiveRecord::Schema.define(version: 20171118165717) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.string "acttopic"
    t.string "acttype"
    t.bigint "secretary_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["secretary_id"], name: "index_activities_on_secretary_id"
    t.index ["user_id"], name: "index_activities_on_user_id"
  end

  create_table "activity_types", force: :cascade do |t|
    t.string "acttypename"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "availabletimes", force: :cascade do |t|
    t.string "title"
    t.datetime "start"
    t.datetime "end"
    t.string "color"
    t.bigint "activity_id"
    t.bigint "member_id"
    t.bigint "user_id"
    t.bigint "schedule_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_id"], name: "index_availabletimes_on_activity_id"
    t.index ["member_id"], name: "index_availabletimes_on_member_id"
    t.index ["schedule_id"], name: "index_availabletimes_on_schedule_id"
    t.index ["user_id"], name: "index_availabletimes_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text "comment"
    t.bigint "user_id"
    t.bigint "activity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_id"], name: "index_comments_on_activity_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "departments", force: :cascade do |t|
    t.string "deptname"
    t.string "deptschool"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "faculties", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "gcalendar"
    t.string "token"
    t.index ["user_id"], name: "index_faculties_on_user_id"
  end

  create_table "members", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "activity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_id"], name: "index_members_on_activity_id"
    t.index ["user_id"], name: "index_members_on_user_id"
  end

  create_table "quotations", force: :cascade do |t|
    t.string "author_name"
    t.string "category"
    t.text "quote"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "schedules", force: :cascade do |t|
    t.string "schname"
    t.datetime "schdate"
    t.boolean "schstart"
    t.boolean "schfinished"
    t.datetime "schdeadline"
    t.bigint "activity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_id"], name: "index_schedules_on_activity_id"
  end

  create_table "secretaries", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "gcalendar"
    t.text "token"
    t.index ["user_id"], name: "index_secretaries_on_user_id"
  end

  create_table "students", force: :cascade do |t|
    t.bigint "user_id"
    t.string "fos"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_students_on_user_id"
  end

  create_table "superadmins", force: :cascade do |t|
    t.string "suadusername"
    t.string "suadpassword_hash"
    t.string "suadpassword_salt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "uname"
    t.string "uemail"
    t.string "udept"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "activities", "secretaries"
  add_foreign_key "activities", "users"
  add_foreign_key "availabletimes", "activities"
  add_foreign_key "availabletimes", "members"
  add_foreign_key "availabletimes", "schedules"
  add_foreign_key "availabletimes", "users"
  add_foreign_key "comments", "activities"
  add_foreign_key "comments", "users"
  add_foreign_key "faculties", "users"
  add_foreign_key "members", "activities"
  add_foreign_key "members", "users"
  add_foreign_key "schedules", "activities"
  add_foreign_key "secretaries", "users"
  add_foreign_key "students", "users"
end
