require 'pg'
require 'sequel'

DB=Sequel.connect(:adapter => 'postgres', :host => 'localhost', :database => 'stats_development', :user=>'postgres', :password=>'pingpong21')

class CreateTable

    def self.get_salaries
      require_relative "../../script/get_player_salaries"
    end
    get_salaries


    def self.create_seven_day_avg
        DB << "DROP TABLE IF EXISTS seven_days;
            CREATE TABLE seven_days AS
            SELECT boxscores.player_name, boxscores.fd_points
            FROM boxscores, todays_games
            WHERE boxscores.date >= (CURRENT_DATE - INTERVAL '8days')
            AND boxscores.player_name=todays_games.player_name;
            "
    end
    create_seven_day_avg


    def self.create_fourteen_day_avg
        DB << "DROP TABLE IF EXISTS fourteen_days;
            CREATE TABLE fourteen_days AS
            SELECT boxscores.player_name, boxscores.fd_points
            FROM boxscores, todays_games
            WHERE boxscores.date >= (CURRENT_DATE - INTERVAL '15days')
            AND boxscores.player_name=todays_games.player_name;
            "
    end
    create_fourteen_day_avg


    def self.create_injury_list_table
        injury_list=eval(File.read(File.expand_path("../../../script/injury_list", __FILE__)))
        DB << "DROP TABLE IF EXISTS injury_list;
              CREATE TABLE injury_list 
                (name VARCHAR (32), date DATE, team_name VARCHAR (32), injury VARCHAR(500), notes VARCHAR(500))"
        
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
          DB << "INSERT INTO injury_list 
                  (name, date, team_name, injury, notes) 
                  VALUES ('#{first} #{last}', '#{xdate}', '#{xteam}', '#{xinjury}', '#{xnotes}');
                
                UPDATE todays_games 
                SET injury=(SELECT 
                    injury_list.injury 
                    FROM injury_list 
                    WHERE injury_list.name=todays_games.player_name), 
                notes=(SELECT 
                    injury_list.notes 
                    FROM injury_list 
                    WHERE injury_list.name=todays_games.player_name), 
                injury_date=(SELECT 
                    injury_list.date 
                    FROM injury_list 
                    WHERE injury_list.name=todays_games.player_name);"
        end
    end
    create_injury_list_table

    def self.update_players
        DB << "UPDATE players
            SET avg_fd_points = (points+(rebounds*1.2)+(assists*1.5)+(blocks*2)+(steals*2)+(turnovers*-1))
            "

    end
    update_players

    def self.update_todays_games
        DB << "UPDATE todays_games
            SET salary ='-1'
            WHERE salary='0'
            OR salary IS NULL;

            UPDATE todays_games 
            SET projected_fd_points = round((salary/1000*6),2); 

            UPDATE todays_games 
            SET avg_seven_days=round((SELECT avg(fd_points) FROM seven_days 
            WHERE seven_days.player_name=todays_games.player_name),2); 

            UPDATE todays_games 
            SET avg_fourteen_days=round((SELECT avg(fd_points) FROM fourteen_days 
            WHERE fourteen_days.player_name=todays_games.player_name),2);

            UPDATE todays_games 
            SET avg_fd_points=
              ( 
                SELECT avg_fd_points
                FROM players 
                WHERE players.player_name=todays_games.player_name 
              );"

    end
    update_todays_games

    def self.update_plus_minus
        DB << "UPDATE todays_games 
            SET plus_minus_percentage = round((avg_fd_points/projected_fd_points),2);
            "
    end
    update_plus_minus
end








