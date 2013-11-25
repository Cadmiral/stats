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

ActiveRecord::Schema.define(version: 20131125185558) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "player", id: false, force: true do |t|
    t.string "last_name",  limit: nil
    t.string "first_name", limit: nil
    t.string "points",     limit: nil
    t.string "rebounds",   limit: nil
    t.string "assists",    limit: nil
    t.string "blocks",     limit: nil
    t.string "steals",     limit: nil
    t.string "turnovers",  limit: nil
  end

  create_table "players", force: true do |t|
    t.string  "first"
    t.string  "last"
    t.integer "points"
    t.integer "rebounds"
    t.integer "assists"
    t.integer "steals"
    t.integer "blocks"
    t.integer "turnovers"
  end

end
