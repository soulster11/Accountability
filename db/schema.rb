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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120521220241) do

  create_table "attendances", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "service_id"
    t.integer  "person_id"
    t.integer  "status_id",  :default => 8
    t.boolean  "contacted"
    t.text     "note"
  end

  add_index "attendances", ["person_id"], :name => "index_attendances_on_person_id"
  add_index "attendances", ["service_id"], :name => "index_attendances_on_service_id"
  add_index "attendances", ["status_id"], :name => "index_attendances_on_status_id"

  create_table "groups", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "designation"
    t.integer  "leader_id"
    t.integer  "parent_id"
    t.integer  "position"
    t.integer  "network_id"
  end

  create_table "memberships", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "person_id"
    t.integer  "group_id"
  end

  create_table "networks", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "designation"
  end

  create_table "people", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "type_id"
    t.integer  "parent_id"
    t.integer  "position"
    t.integer  "residence_id"
    t.string   "email_address"
    t.string   "cell_number"
    t.boolean  "active",               :default => true
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
  end

  create_table "residences", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "address1"
    t.string   "address2"
    t.string   "city",         :default => "Columbus"
    t.string   "state",        :default => "IN"
    t.string   "zip",          :default => "47201"
    t.string   "phone_number"
  end

  create_table "schedules", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "standard_time"
    t.string   "default_day"
    t.integer  "network_id"
    t.string   "description"
  end

  create_table "services", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "dateandtime"
    t.text     "description"
    t.integer  "network_id"
  end

  create_table "statuses", :force => true do |t|
    t.string "designation"
  end

  create_table "types", :force => true do |t|
    t.string "designation"
  end

  create_table "users", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.string   "password"
    t.integer  "person_id"
    t.boolean  "administrator"
    t.string   "salt"
  end

end
