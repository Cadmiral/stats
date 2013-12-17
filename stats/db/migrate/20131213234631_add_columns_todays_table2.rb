class AddColumnsTodaysTable2 < ActiveRecord::Migration
  def change
  	  	 create_table "todays_games", id: false, force: true do |t|
    t.date    "date"
    t.string  "player_name",      limit: 32
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
end
