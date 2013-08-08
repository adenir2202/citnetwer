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

ActiveRecord::Schema.define(version: 20130801172811) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: true do |t|
    t.text     "code",                     default: "#",    null: false
    t.string   "name",                     default: "evt1", null: false
    t.text     "argument"
    t.text     "answer"
    t.integer  "answerType",     limit: 2,                  null: false
    t.integer  "language",       limit: 2, default: 1,      null: false
    t.integer  "transaction_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["transaction_id"], name: "index_events_on_transaction_id", using: :btree

  create_table "transactions", force: true do |t|
    t.integer  "code",                   default: 0,       null: false
    t.string   "name",        limit: 64, default: "tr001", null: false
    t.text     "description"
    t.text     "argument"
    t.integer  "answerType",  limit: 2,  default: 0,       null: false
    t.text     "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
