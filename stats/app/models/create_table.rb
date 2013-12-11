require 'pg'
require 'sequel'

DB=Sequel.connect(:adapter => 'postgres', :host => 'localhost', :database => 'stats_development', :user=>'postgres', :password=>'pingpong21')

class CreateTable

    def self.create_player_table
      player_avg_table=eval(File.read(File.expand_path("../../../script/player_avg", __FILE__)))

      DB << "DROP TABLE IF EXISTS player" << "CREATE TABLE player (player_id SERIAL, player_name VARCHAR(32), pos VARCHAR(32), team_name VARCHAR(32), mins DECIMAL, points DECIMAL, rebounds DECIMAL, assists DECIMAL, steals DECIMAL, blocks DECIMAL, turnovers DECIMAL, avg_fd_points DECIMAL)" 
      player_avg_table.each do |x|
            xname=x[:name]
            if xname.chomp == ""
              player_avg_table.delete x
            else
              player = xname.split(/\s+/,2)
                strip_first=player[0]
                strip_first_2=strip_first.tr("'","")
                strip_first_3=strip_first_2.tr(".","")
                strip_first_4=strip_first_3.tr("-","")
                first=strip_first_4.tr(" ","")
                strip_last=player[1]
                strip_last_2=strip_last.tr("'","")
                strip_last_3=strip_last_2.tr(".","")
                strip_last_4=strip_last_3.tr("-","")
                last=strip_last_4.tr(" ","")
            xpos=x[:pos]
            xteam=x[:team]
            xmins=x[:mins]            
            xpoints=x[:points]
            xrebounds=x[:rebounds]
            xassists=x[:assists]
            xsteals=x[:steals]
            xblocks=x[:blocks]
            xturnovers=x[:turnovers]
            DB << "INSERT INTO player (player_name, pos, team_name, mins, points, rebounds, assists, steals, blocks, turnovers) VALUES ('#{first} #{last}', '#{xpos}', '#{xteam}', '#{xmins}', '#{xpoints}', '#{xrebounds}', '#{xassists}', '#{xsteals}', '#{xblocks}', '#{xturnovers}')"
        end
        #UPDATE these players POS and ADD team name & UPDATE SUM of avg_fd_points
        DB << "UPDATE player SET pos='SF', team_name='SAC' WHERE player_name='Derrick Williams'; UPDATE player SET pos='PF', team_name='MIN' WHERE player_name='Luc MbahaMoute'; UPDATE player SET avg_fd_points = (points+(rebounds*1.2)+(assists+1.5)+(blocks*2)+(steals*2)+(turnovers*-1))"
      end
    end
    # create_player_table


    def self.create_boxscore_table
        tables=eval(File.read(File.expand_path("../../../script/player_boxscore", __FILE__)))
        DB << "DROP TABLE IF EXISTS boxscore" << "CREATE TABLE boxscore (date DATE, team_name VARCHAR (32), player_name VARCHAR(32), player_id INT, home VARCHAR(32), opponent VARCHAR(32), mins VARCHAR(32), points INT, fg_attempts INT, fg_percent DECIMAL, rebounds INT, assists INT, steals INT, blocks INT, turnovers INT, fouls INT, salary INT, fd_points DECIMAL)" 
        tables.each do |x|
          xname=x[:name]
          xdate=x[:date]
          xteam=x[:team]
          xhome=x[:home]
          xopponent=x[:opponent]
          xmins=x[:mins]
          xpoints=x[:points]
          xfg_attempts=x[:fg_attempts]
          xfg_percent=x[:fg_percent]
          xrebounds=x[:rebounds]
          xassists=x[:assists]
          xsteals=x[:steals]
          xblocks=x[:blocks]
          xturnovers=x[:turnovers]
          xfouls=x[:fouls]
          DB << "INSERT INTO boxscore (player_name, team_name, date, home, opponent, mins, points, fg_attempts, fg_percent, rebounds, assists, steals, blocks, turnovers, fouls) VALUES ('#{xname}', '#{xteam}', '#{xdate}', '#{xhome}', '#{xopponent}', '#{xmins}', '#{xpoints}', '#{xfg_attempts}', '#{xfg_percent}', '#{xrebounds}', '#{xassists}', '#{xsteals}', '#{xblocks}', '#{xturnovers}', '#{xfouls}')"
        end
        #UPDATE boxscore player_id to match TABLE player.player_id & UPDATE SUM of fd_points
        DB << "UPDATE boxscore SET player_id = player.player_id FROM player where player.player_name = boxscore.player_name; UPDATE boxscore SET fd_points = (points+(rebounds*1.2)+(assists+1.5)+(blocks*2)+(steals*2)+(turnovers*-1))"
    end
    # create_boxscore_table


    def self.create_schedule_table
        tables=eval(File.read(File.expand_path("../../../script/nba_schedule", __FILE__)))
        DB << "DROP TABLE IF EXISTS schedule" << "CREATE TABLE schedule (date DATE, team_name VARCHAR (32), team_score INT, opponent VARCHAR(32), opponent_score INT)"
        tables.each do |x|
          xdate=x[:date]
          xteam=x[:team]
          xteam_score=x[:team_score]
          xopponent=x[:opponent]
          xopponent_score=x[:opponent_score]
          DB << "INSERT INTO schedule (date, team_name, team_score, opponent, opponent_score) VALUES ('#{xdate}', '#{xteam}', '#{xteam_score}', '#{xopponent}', '#{xopponent_score}')"
        end
    end
    # create_schedule_table

    def self.create_todays_game_table
        DB << "DROP TABLE IF EXISTS todays_game" << "SELECT schedule.date, player.player_name, player.pos, player.team_name, player.avg_fd_points INTO todays_game FROM player, schedule WHERE schedule.date = current_date AND (player.team_name=schedule.team_name OR schedule.opponent=player.team_name) ORDER BY player.avg_fd_points DESC;"
        DB << "ALTER TABLE todays_game ADD COLUMN opponent VARCHAR(32), ADD COLUMN salary INTEGER, ADD COLUMN dollar_per_point DECIMAL, ADD COLUMN injury_date DATE, ADD COLUMN injury VARCHAR(500), ADD COLUMN notes VARCHAR(500)"

        #update todays_game table with data from other tables
        DB << "UPDATE todays_game SET opponent=schedule.team_name FROM schedule WHERE todays_game.team_name = schedule.opponent AND todays_game.date=schedule.date"
        DB << "UPDATE todays_game SET opponent=schedule.opponent FROM schedule WHERE todays_game.team_name = schedule.team_name AND todays_game.date=schedule.date"
    end
    # create_todays_game_table


    def self.create_injury_list_table
        injury_list=eval(File.read(File.expand_path("../../../script/injury_list", __FILE__)))
        DB << "DROP TABLE IF EXISTS injury_list" << "CREATE TABLE injury_list (name VARCHAR (32), date DATE, team_name VARCHAR (32), injury VARCHAR(500), notes VARCHAR(500))"
        injury_list.each do |x|
          xname=x[:name]
            player = xname.split(/\s+/,2)
                strip_first=player[0]
                strip_first_2=strip_first.tr("'","")
                strip_first_3=strip_first_2.tr(".","")
                strip_first_4=strip_first_3.tr("-","")
                first=strip_first_4.tr(" ","")
                strip_last=player[1]
                strip_last_2=strip_last.tr("'","")
                strip_last_3=strip_last_2.tr(".","")
                strip_last_4=strip_last_3.tr("-","")
                last=strip_last_4.tr(" ","")
          xdate=x[:date]
          xteam=x[:team]
          xinjury=x[:injury]
          xnotes=x[:notes]
          DB << "INSERT INTO injury_list (name, date, team_name, injury, notes) VALUES ('#{first} #{last}', '#{xdate}', '#{xteam}', '#{xinjury}', '#{xnotes}')"
          DB << "UPDATE todays_game SET injury=(select injury_list.injury from injury_list where injury_list.name=todays_game.player_name), notes=(select injury_list.notes from injury_list where injury_list.name=todays_game.player_name), injury_date=(select injury_list.date from injury_list where injury_list.name=todays_game.player_name)"

        end
    end
    create_injury_list_table


    def self.update_salary
        player_salary=File.read(File.expand_path("../../../script/player_daily_salaries", __FILE__))
        
        get_salary = player_salary.split(/\n/)
        get_salary.each do |a|
        if match = a.match(/\s*(\w+)\s+(\w+)\s+(\w+)\s*/)
        salary, first, last1= match.captures
        end
        # last="#{last1}#{last2}"
        # puts last
        puts last1
        # puts first
        #   xsalary=x[:salary]
        #   DB << "UPDATE todays_game SET salary = #{xsalary} WHERE player_name = '#{xname}'"
        end
    end
    # update_salary


    def self.create_salary_archive_table
        DB << "DELETE FROM todays_game WHERE salary=0"
        DB << "CREATE TABLE IF NOT EXISTS salary_archive (date DATE, player_name VARCHAR(32), pos VARCHAR (32), team_name VARCHAR (32), opponent VARCHAR(32), avg_fd_points DECIMAL, salary INTEGER, dollar_per_point DECIMAL)" 
        DB << "INSERT INTO salary_archive (date, player_name, pos, team_name, opponent, avg_fd_points, salary, dollar_per_point) SELECT date, player_name, pos, team_name, opponent, avg_fd_points, salary, dollar_per_point FROM todays_game WHERE date = current_date"
    end
    # update_todays_game_table

end







