# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090115015128) do

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.string   "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "facebook_statuses", :force => true do |t|
    t.text     "message"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "facebook_users", :force => true do |t|
    t.string   "url"
    t.string   "nickname"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "twitter_followings", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "twitter_user_id"
    t.integer  "following_id"
  end

  create_table "twitter_statuses", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "in_reply_to_status_id"
    t.integer  "in_reply_to_user_id"
    t.integer  "twitter_user_id"
    t.string   "text"
  end

  create_table "twitter_users", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "user_created_at"
    t.string   "screen_name"
    t.string   "profile_image_url"
  end

end
