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

ActiveRecord::Schema.define(version: 20131214005227) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "boxscores", force: true do |t|
    t.date    "date"
    t.string  "team_name",   limit: 32
    t.string  "player_name", limit: 32
    t.integer "player_id"
    t.string  "home",        limit: 32
    t.string  "opponent",    limit: 32
    t.string  "mins",        limit: 32
    t.integer "points"
    t.integer "fg_attempts"
    t.decimal "fg_percent"
    t.integer "rebounds"
    t.integer "assists"
    t.integer "steals"
    t.integer "blocks"
    t.integer "turnovers"
    t.integer "fouls"
    t.integer "salary"
    t.decimal "fd_points"
  end

  create_table "injury_list", id: false, force: true do |t|
    t.string "name",      limit: 32
    t.date   "date"
    t.string "team_name", limit: 32
    t.string "injury",    limit: 500
    t.string "notes",     limit: 500
  end

  create_table "players", id: false, force: true do |t|
    t.integer "player_id",                default: "nextval('players_player_id_seq'::regclass)", null: false
    t.string  "player_name",   limit: 32
    t.string  "pos",           limit: 32
    t.string  "team_name",     limit: 32
    t.decimal "mins"
    t.decimal "points"
    t.decimal "rebounds"
    t.decimal "assists"
    t.decimal "steals"
    t.decimal "blocks"
    t.decimal "turnovers"
    t.decimal "avg_fd_points"
  end

  create_table "salary_archive", id: false, force: true do |t|
    t.date    "date"
    t.string  "player_name",      limit: 32
    t.string  "pos",              limit: 32
    t.string  "team_name",        limit: 32
    t.string  "opponent",         limit: 32
    t.decimal "avg_fd_points"
    t.integer "salary"
    t.decimal "dollar_per_point"
  end

  create_table "schedule", id: false, force: true do |t|
    t.date    "date"
    t.string  "team_name",      limit: 32
    t.integer "team_score"
    t.string  "opponent",       limit: 32
    t.integer "opponent_score"
  end

  create_table "todays_games", id: false, force: true do |t|
    t.date    "date"
    t.string  "player_name",      limit: 32,  null: false
    t.string  "pos",              limit: 32
    t.string  "team_name",        limit: 32
    t.decimal "avg_fd_points"
    t.string  "opponent",         limit: 32
    t.integer "salary"
    t.decimal "dollar_per_point"
    t.date    "injury_date"
    t.string  "injury",           limit: 500
    t.string  "notes",            limit: 500
  end

end
