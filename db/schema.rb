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

ActiveRecord::Schema.define(:version => 20130524124345) do

  create_table "articles", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.string   "source_url"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "karticles", :force => true do |t|
    t.integer  "article_id"
    t.integer  "score"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "kvectors", :force => true do |t|
    t.boolean  "is_known"
    t.integer  "view_count"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
    t.integer  "word_id"
  end

  create_table "users", :force => true do |t|
    t.string   "user_type"
    t.string   "username"
    t.string   "password"
    t.string   "password_hash"
    t.string   "password_salt"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.text     "knowledge_string"
  end

  create_table "words", :force => true do |t|
    t.string   "text"
    t.integer  "difficulty"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
