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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130715174857) do

  create_table "cadenero_accounts", :force => true do |t|
    t.string   "name"
    t.string   "subdomain"
    t.string   "auth_token"
    t.integer  "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cadenero_accounts", ["auth_token"], :name => "index_cadenero_accounts_on_auth_token"
  add_index "cadenero_accounts", ["owner_id"], :name => "index_cadenero_accounts_on_owner_id"

  create_table "cadenero_members", :force => true do |t|
    t.integer  "account_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "auth_token"
  end

  add_index "cadenero_members", ["account_id"], :name => "index_cadenero_members_on_account_id"
  add_index "cadenero_members", ["auth_token"], :name => "index_cadenero_members_on_auth_token"
  add_index "cadenero_members", ["user_id"], :name => "index_cadenero_members_on_user_id"

  create_table "cadenero_users", :force => true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
