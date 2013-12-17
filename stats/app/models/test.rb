require 'pg'
require 'sequel'

DB=Sequel.connect(:adapter => 'postgres', :host => 'localhost', :database => 'stats_development', :user=>'postgres', :password=>'pingpong21')


        DB << "DROP TABLE IF EXISTS todays_games" << "SELECT schedule.date, player.player_name, player.pos, player.team_name, player.avg_fd_points INTO todays_games FROM player, schedule WHERE schedule.date = current_date AND (player.team_name=schedule.team_name OR schedule.opponent=player.team_name) ORDER BY player.avg_fd_points DESC;"
        DB << "ALTER TABLE todays_games ADD COLUMN opponent VARCHAR(32), ADD COLUMN salary INTEGER, ADD COLUMN dollar_per_point DECIMAL, ADD COLUMN injury_date DATE, ADD COLUMN injury VARCHAR(500), ADD COLUMN notes VARCHAR(500), ADD PRIMARY KEY (player_name)"

        #update todays_game table with data from other tables
        DB << "UPDATE todays_games SET opponent=schedule.team_name FROM schedule WHERE todays_games.team_name = schedule.opponent AND todays_games.date=schedule.date"
        DB << "UPDATE todays_games SET opponent=schedule.opponent FROM schedule WHERE todays_games.team_name = schedule.team_name AND todays_games.date=schedule.date"
