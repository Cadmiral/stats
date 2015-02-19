require 'pg'
require 'sequel'

DB=Sequel.connect(:adapter => 'postgres', :host => 'localhost', :database => 'stats_development', :user=>'postgres', :password=>'pingpong21')

class CreateTable

    def self.create_player_table
      player_avg_table=eval(File.read(File.expand_path("../../../script/player_avg", __FILE__)))

      DB << "DROP TABLE IF EXISTS players; 
            CREATE TABLE players 
                (player_id SERIAL, 
                player_name VARCHAR(32), 
                pos VARCHAR(32), 
                team_name VARCHAR(32), 
                mins DECIMAL, 
                points DECIMAL, 
                rebounds DECIMAL, 
                assists DECIMAL, 
                steals DECIMAL, 
                blocks DECIMAL, 
                turnovers DECIMAL, 
                avg_fd_points DECIMAL)" 

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
            DB << "INSERT INTO players 
                    (player_name, pos, team_name, mins, points, rebounds, assists, steals, blocks, turnovers) 
                    VALUES ('#{first} #{last}', '#{xpos}', '#{xteam}', '#{xmins}', '#{xpoints}', '#{xrebounds}', '#{xassists}', '#{xsteals}', '#{xblocks}', '#{xturnovers}')"
      end

      DB <<   "
               UPDATE players SET pos='PG' WHERE player_name='Michael CarterWilliams';  
               UPDATE players SET pos='SG' WHERE player_name='Anthony Morrow'; 
               UPDATE players SET pos='SG' WHERE player_name='Bradley Beal'; 
               UPDATE players SET pos='SG' WHERE player_name='Tyreke Evans'; 
               UPDATE players SET pos='SF' WHERE player_name='Danny Granger'; 
               UPDATE players SET pos='PG' WHERE player_name='John Jenkins'; 
               UPDATE players SET pos='SG' WHERE player_name='Gary Harris'; 
               UPDATE players SET pos='SG' WHERE player_name='Nick Young'; 
               UPDATE players SET pos='PG' WHERE player_name='Jose Calderon'; 
               UPDATE players SET pos='SG' WHERE player_name='Victor Oladipo'; 
               UPDATE players SET pos='SG' WHERE player_name='Eric Bledsoe'; 
               UPDATE players SET pos='PG' WHERE player_name='Goran Dragic';             
               UPDATE players SET pos='PG' WHERE player_name='Nick Calathes'; 
               UPDATE players SET pos='SF' WHERE player_name='Josh Smith'; 
               UPDATE players SET pos='SF' WHERE player_name='Kevin Durant'; 
              "
      #         UPDATE players SET pos='C' WHERE player_name='DeJuan Blair'; 
      #         UPDATE players SET pos='SF' WHERE player_name='LeBron James'; 
      #         UPDATE players SET pos='PF' WHERE player_name='Tim Duncan'; 
      #         UPDATE players SET pos='SF', team_name='SAC' WHERE player_name='Derrick Williams'; 
      #         UPDATE players SET pos='PF', team_name='MIN' WHERE player_name='Luc MbahaMoute'; 
      #         UPDATE players SET pos='PG', team_name='SAC' WHERE player_name='Greivis Vasquez'; 
      #         UPDATE players SET team_name='GSW' WHERE player_name='Jordan Crawford';
      #         UPDATE players SET team_name='SAC' WHERE player_name='Quincy Acy';
      #         UPDATE players SET avg_fd_points = (points+(rebounds*1.2)+(assists+1.5)+(blocks*2)+(steals*2)+(turnovers*-1))
              
      end
    end
    create_player_table


    def self.create_boxscores_table
        tables=eval(File.read(File.expand_path("../../../script/player_boxscore", __FILE__)))
        DB << "DROP TABLE IF EXISTS boxscores; 
              CREATE TABLE boxscores 
                (id SERIAL PRIMARY KEY, 
                date DATE, 
                team_name VARCHAR (32), 
                player_name VARCHAR(32), 
                player_id INT, 
                pos VARCHAR(32), 
                home VARCHAR(32), 
                opponent VARCHAR(32), 
                mins DECIMAL, 
                points INT, 
                fg_attempts INT, 
                fg_percent DECIMAL, 
                rebounds INT, 
                assists INT, 
                steals INT, 
                blocks INT, 
                turnovers INT, 
                fouls INT, 
                salary INT, 
                fd_points DECIMAL)" 
        tables.each do |x|
          xname=x[:name]
          xdate=x[:date]
          xteam=x[:team]
          xhome=x[:home]
          xopponent=x[:opponent]
          mins=x[:mins]
            xmins=mins.tr(":",".")
          xpoints=x[:points]
          xfg_attempts=x[:fg_attempts]
          xfg_percent=x[:fg_percent]
          xrebounds=x[:rebounds]
          xassists=x[:assists]
          xsteals=x[:steals]
          xblocks=x[:blocks]
          xturnovers=x[:turnovers]
          xfouls=x[:fouls]
          DB << "INSERT INTO boxscores 
          (player_name, team_name, date, home, opponent, mins, points, fg_attempts, fg_percent, rebounds, assists, steals, blocks, turnovers, fouls) 
          VALUES ('#{xname}', '#{xteam}', '#{xdate}', '#{xhome}', '#{xopponent}', '#{xmins}', '#{xpoints}', '#{xfg_attempts}', '#{xfg_percent}', '#{xrebounds}', '#{xassists}', '#{xsteals}', '#{xblocks}', '#{xturnovers}', '#{xfouls}')"      
        end
        #UPDATE boxscore player_id to match TABLE player.player_id & UPDATE SUM of fd_points
        DB << "UPDATE boxscores 
              SET player_id = players.player_id 
              FROM players 
              WHERE players.player_name = boxscores.player_name; 

              UPDATE boxscores 
              SET pos=players.pos 
              FROM players 
              WHERE boxscores.player_name = players.player_name; 

              UPDATE boxscores 
              SET fd_points = (points+(rebounds*1.2)+(assists*1.5)+(blocks*2)+(steals*2)+(turnovers*-1))"
    end
    create_boxscores_table


    def self.create_schedule_table
        tables=eval(File.read(File.expand_path("../../../script/nba_schedule", __FILE__)))
        DB << "DROP TABLE IF EXISTS schedule;
              CREATE TABLE schedule 
              (date DATE, team_name VARCHAR (32), team_score INT, opponent VARCHAR(32), opponent_score INT)"
        tables.each do |x|
          xdate=x[:date]
          xteam=x[:team]
          xteam_score=x[:team_score]
          xopponent=x[:opponent]
          xopponent_score=x[:opponent_score]
          DB << "INSERT INTO schedule 
          (date, team_name, team_score, opponent, opponent_score) 
          VALUES ('#{xdate}', '#{xteam}', '#{xteam_score}', '#{xopponent}', '#{xopponent_score}')"
        end
    end
    create_schedule_table


    def self.create_todays_game_table
        DB << "DROP TABLE IF EXISTS todays_games;
              SELECT schedule.date, players.player_name, players.pos, players.team_name, players.avg_fd_points 
                INTO todays_games 
                FROM players, schedule 
                WHERE schedule.date = current_date 
                AND (players.team_name=schedule.team_name OR schedule.opponent=players.team_name) 
                ORDER BY players.avg_fd_points DESC;
              
              ALTER TABLE todays_games 
                ADD COLUMN fd_points_vs_opp DECIMAL, 
                ADD COLUMN opponent VARCHAR(32), 
                ADD COLUMN salary DECIMAL, 
                ADD COLUMN projected_fd_points DECIMAL, 
                ADD COLUMN plus_minus_percentage DECIMAL, 
                ADD COLUMN pos_advantage DECIMAL, 
                ADD COLUMN injury_date DATE, 
                ADD COLUMN injury VARCHAR(500), 
                ADD COLUMN notes VARCHAR(500),
                ADD Column avg_fd_vs_opp DECIMAL, 
                ADD Column avg_seven_days DECIMAL,
                ADD Column avg_fourteen_days DECIMAL,                 
                ADD PRIMARY KEY (player_name);

              UPDATE todays_games 
                SET opponent=schedule.team_name 
                FROM schedule 
                WHERE todays_games.team_name = schedule.opponent 
                AND todays_games.date=schedule.date;

              UPDATE todays_games 
                SET opponent=schedule.opponent 
                FROM schedule 
                WHERE todays_games.team_name = schedule.team_name 
                AND todays_games.date=schedule.date;

              UPDATE todays_games 
                  SET avg_fd_vs_opp=
                  ( 
                    SELECT ROUND(AVG(boxscores.fd_points),2) 
                    FROM boxscores 
                    WHERE boxscores.player_name=todays_games.player_name 
                    AND todays_games.opponent=boxscores.opponent
                  );"
        
    end
    create_todays_game_table

    def self.opponent_stats_by_pos
        DB << "DROP TABLE IF EXISTS opponent_stats_by_pos;
          CREATE TABLE opponent_stats_by_pos (
            team_name VARCHAR(32),
            pg_avg_fd DECIMAL, sg_avg_fd DECIMAL, sf_avg_fd DECIMAL, pf_avg_fd DECIMAL, c_avg_fd DECIMAL,
            pg_points DECIMAL, pg_rebounds DECIMAL, pg_assists DECIMAL, pg_steals DECIMAL, pg_blocks DECIMAL, pg_turnovers DECIMAL, 
            sg_points DECIMAL, sg_rebounds DECIMAL, sg_assists DECIMAL, sg_steals DECIMAL, sg_blocks DECIMAL, sg_turnovers DECIMAL, 
            sf_points DECIMAL, sf_rebounds DECIMAL, sf_assists DECIMAL, sf_steals DECIMAL, sf_blocks DECIMAL, sf_turnovers DECIMAL, 
            pf_points DECIMAL, pf_rebounds DECIMAL, pf_assists DECIMAL, pf_steals DECIMAL, pf_blocks DECIMAL, pf_turnovers DECIMAL, 
            c_points DECIMAL, c_rebounds DECIMAL, c_assists DECIMAL, c_steals DECIMAL, c_blocks DECIMAL, c_turnovers DECIMAL);

            INSERT INTO opponent_stats_by_pos (team_name) SELECT DISTINCT players.team_name
            FROM players
            WHERE players.team_name!='';

            UPDATE opponent_stats_by_pos 
            SET pg_avg_fd=(SELECT ROUND(AVG(boxscores.fd_points),2) 
            FROM boxscores 
            WHERE boxscores.pos='PG' 
            AND opponent_stats_by_pos.team_name=boxscores.opponent 
            AND boxscores.mins>='10');

            UPDATE opponent_stats_by_pos 
            SET sg_avg_fd=(SELECT ROUND(AVG(boxscores.fd_points),2) 
            FROM boxscores 
            WHERE boxscores.pos='SG' 
            AND opponent_stats_by_pos.team_name=boxscores.opponent 
            AND boxscores.mins>='10');

            UPDATE opponent_stats_by_pos 
            SET sf_avg_fd=(SELECT ROUND(AVG(boxscores.fd_points),2) 
            FROM boxscores 
            WHERE boxscores.pos='SF' 
            AND opponent_stats_by_pos.team_name=boxscores.opponent 
            AND boxscores.mins>='10');

            UPDATE opponent_stats_by_pos 
            SET pf_avg_fd=(SELECT ROUND(AVG(boxscores.fd_points),2) 
            FROM boxscores 
            WHERE boxscores.pos='PF' 
            AND opponent_stats_by_pos.team_name=boxscores.opponent 
            AND boxscores.mins>='10');

            UPDATE opponent_stats_by_pos 
            SET c_avg_fd=(SELECT ROUND(AVG(boxscores.fd_points),2) 
            FROM boxscores 
            WHERE boxscores.pos='C' 
            AND opponent_stats_by_pos.team_name=boxscores.opponent 
            AND boxscores.mins>='10');

            UPDATE opponent_stats_by_pos 
            SET pg_points=(SELECT ROUND(AVG(boxscores.points),2) 
            FROM boxscores 
            WHERE boxscores.pos='PG' 
            AND opponent_stats_by_pos.team_name=boxscores.opponent 
            AND boxscores.mins>='10');

            UPDATE opponent_stats_by_pos 
            SET sg_points=(SELECT ROUND(AVG(boxscores.points),2) 
            FROM boxscores 
            WHERE boxscores.pos='SG' 
            AND opponent_stats_by_pos.team_name=boxscores.opponent 
            AND boxscores.mins>='10');

            UPDATE opponent_stats_by_pos 
            SET sf_points=(SELECT ROUND(AVG(boxscores.points),2) 
            FROM boxscores 
            WHERE boxscores.pos='SF' 
            AND opponent_stats_by_pos.team_name=boxscores.opponent 
            AND boxscores.mins>='10');

            UPDATE opponent_stats_by_pos 
            SET pf_points=(SELECT ROUND(AVG(boxscores.points),2) 
            FROM boxscores 
            WHERE boxscores.pos='PF' 
            AND opponent_stats_by_pos.team_name=boxscores.opponent 
            AND boxscores.mins>='10');

            UPDATE opponent_stats_by_pos 
            SET c_points=(SELECT ROUND(AVG(boxscores.points),2) 
            FROM boxscores 
            WHERE boxscores.pos='C' 
            AND opponent_stats_by_pos.team_name=boxscores.opponent 
            AND boxscores.mins>='10');

            UPDATE opponent_stats_by_pos 
            SET pg_rebounds=(SELECT ROUND(AVG(boxscores.rebounds),2) 
            FROM boxscores 
            WHERE boxscores.pos='PG' 
            AND opponent_stats_by_pos.team_name=boxscores.opponent 
            AND boxscores.mins>='10');

            UPDATE opponent_stats_by_pos 
            SET sg_rebounds=(SELECT ROUND(AVG(boxscores.rebounds),2) 
            FROM boxscores 
            WHERE boxscores.pos='SG' 
            AND opponent_stats_by_pos.team_name=boxscores.opponent 
            AND boxscores.mins>='10');

            UPDATE opponent_stats_by_pos 
            SET sf_rebounds=(SELECT ROUND(AVG(boxscores.rebounds),2) 
            FROM boxscores 
            WHERE boxscores.pos='SF' 
            AND opponent_stats_by_pos.team_name=boxscores.opponent 
            AND boxscores.mins>='10');

            UPDATE opponent_stats_by_pos 
            SET pf_rebounds=(SELECT ROUND(AVG(boxscores.rebounds),2) 
            FROM boxscores 
            WHERE boxscores.pos='PF' 
            AND opponent_stats_by_pos.team_name=boxscores.opponent 
            AND boxscores.mins>='10');

            UPDATE opponent_stats_by_pos 
            SET c_rebounds=(SELECT ROUND(AVG(boxscores.rebounds),2) 
            FROM boxscores 
            WHERE boxscores.pos='C' 
            AND opponent_stats_by_pos.team_name=boxscores.opponent 
            AND boxscores.mins>='10');

            UPDATE opponent_stats_by_pos 
            SET pg_assists=(SELECT ROUND(AVG(boxscores.assists),2) 
            FROM boxscores 
            WHERE boxscores.pos='PG' 
            AND opponent_stats_by_pos.team_name=boxscores.opponent 
            AND boxscores.mins>='10');

            UPDATE opponent_stats_by_pos 
            SET sg_assists=(SELECT ROUND(AVG(boxscores.assists),2) 
            FROM boxscores 
            WHERE boxscores.pos='SG' 
            AND opponent_stats_by_pos.team_name=boxscores.opponent 
            AND boxscores.mins>='10');

            UPDATE opponent_stats_by_pos 
            SET sf_assists=(SELECT ROUND(AVG(boxscores.assists),2) 
            FROM boxscores 
            WHERE boxscores.pos='SF' 
            AND opponent_stats_by_pos.team_name=boxscores.opponent 
            AND boxscores.mins>='10');

            UPDATE opponent_stats_by_pos 
            SET pf_assists=(SELECT ROUND(AVG(boxscores.assists),2) 
            FROM boxscores 
            WHERE boxscores.pos='PF' 
            AND opponent_stats_by_pos.team_name=boxscores.opponent 
            AND boxscores.mins>='10');

            UPDATE opponent_stats_by_pos 
            SET c_assists=(SELECT ROUND(AVG(boxscores.assists),2) 
            FROM boxscores 
            WHERE boxscores.pos='C' 
            AND opponent_stats_by_pos.team_name=boxscores.opponent 
            AND boxscores.mins>='10');


            UPDATE opponent_stats_by_pos 
            SET pg_steals=(SELECT ROUND(AVG(boxscores.steals),2) 
            FROM boxscores 
            WHERE boxscores.pos='PG' 
            AND opponent_stats_by_pos.team_name=boxscores.opponent 
            AND boxscores.mins>='10');

            UPDATE opponent_stats_by_pos 
            SET sg_steals=(SELECT ROUND(AVG(boxscores.steals),2) 
            FROM boxscores 
            WHERE boxscores.pos='SG' 
            AND opponent_stats_by_pos.team_name=boxscores.opponent 
            AND boxscores.mins>='10');

            UPDATE opponent_stats_by_pos 
            SET sf_steals=(SELECT ROUND(AVG(boxscores.steals),2) 
            FROM boxscores 
            WHERE boxscores.pos='SF' 
            AND opponent_stats_by_pos.team_name=boxscores.opponent 
            AND boxscores.mins>='10');

            UPDATE opponent_stats_by_pos 
            SET pf_steals=(SELECT ROUND(AVG(boxscores.steals),2) 
            FROM boxscores 
            WHERE boxscores.pos='PF' 
            AND opponent_stats_by_pos.team_name=boxscores.opponent 
            AND boxscores.mins>='10');

            UPDATE opponent_stats_by_pos 
            SET c_steals=(SELECT ROUND(AVG(boxscores.steals),2) 
            FROM boxscores 
            WHERE boxscores.pos='C' 
            AND opponent_stats_by_pos.team_name=boxscores.opponent 
            AND boxscores.mins>='10');

            UPDATE opponent_stats_by_pos 
            SET pg_blocks=(SELECT ROUND(AVG(boxscores.blocks),2) 
            FROM boxscores 
            WHERE boxscores.pos='PG' 
            AND opponent_stats_by_pos.team_name=boxscores.opponent 
            AND boxscores.mins>='10');

            UPDATE opponent_stats_by_pos 
            SET sg_blocks=(SELECT ROUND(AVG(boxscores.blocks),2) 
            FROM boxscores 
            WHERE boxscores.pos='SG' 
            AND opponent_stats_by_pos.team_name=boxscores.opponent 
            AND boxscores.mins>='10');

            UPDATE opponent_stats_by_pos 
            SET sf_blocks=(SELECT ROUND(AVG(boxscores.blocks),2) 
            FROM boxscores 
            WHERE boxscores.pos='SF' 
            AND opponent_stats_by_pos.team_name=boxscores.opponent 
            AND boxscores.mins>='10');

            UPDATE opponent_stats_by_pos 
            SET pf_blocks=(SELECT ROUND(AVG(boxscores.blocks),2) 
            FROM boxscores 
            WHERE boxscores.pos='PF' 
            AND opponent_stats_by_pos.team_name=boxscores.opponent 
            AND boxscores.mins>='10');

            UPDATE opponent_stats_by_pos 
            SET c_blocks=(SELECT ROUND(AVG(boxscores.blocks),2) 
            FROM boxscores 
            WHERE boxscores.pos='C' 
            AND opponent_stats_by_pos.team_name=boxscores.opponent 
            AND boxscores.mins>='10');

            UPDATE opponent_stats_by_pos 
            SET pg_turnovers=(SELECT ROUND(AVG(boxscores.turnovers),2) 
            FROM boxscores 
            WHERE boxscores.pos='PG' 
            AND opponent_stats_by_pos.team_name=boxscores.opponent 
            AND boxscores.mins>='10');

            UPDATE opponent_stats_by_pos 
            SET sg_turnovers=(SELECT ROUND(AVG(boxscores.turnovers),2) 
            FROM boxscores 
            WHERE boxscores.pos='SG' 
            AND opponent_stats_by_pos.team_name=boxscores.opponent 
            AND boxscores.mins>='10');

            UPDATE opponent_stats_by_pos 
            SET sf_turnovers=(SELECT ROUND(AVG(boxscores.turnovers),2) 
            FROM boxscores 
            WHERE boxscores.pos='SF' 
            AND opponent_stats_by_pos.team_name=boxscores.opponent 
            AND boxscores.mins>='10');

            UPDATE opponent_stats_by_pos 
            SET pf_turnovers=(SELECT ROUND(AVG(boxscores.turnovers),2) 
            FROM boxscores 
            WHERE boxscores.pos='PF' 
            AND opponent_stats_by_pos.team_name=boxscores.opponent 
            AND boxscores.mins>='10');

            UPDATE opponent_stats_by_pos 
            SET c_turnovers=(SELECT ROUND(AVG(boxscores.turnovers),2) 
            FROM boxscores 
            WHERE boxscores.pos='C' 
            AND opponent_stats_by_pos.team_name=boxscores.opponent 
            AND boxscores.mins>='10');

            UPDATE todays_games
            SET fd_points_vs_opp =
              (CASE
              WHEN todays_games.pos = 'PG' THEN opponent_stats_by_pos.pg_avg_fd
              WHEN todays_games.pos = 'SG' THEN opponent_stats_by_pos.sg_avg_fd
              WHEN todays_games.pos = 'SF' THEN opponent_stats_by_pos.sf_avg_fd
              WHEN todays_games.pos = 'PF' THEN opponent_stats_by_pos.pf_avg_fd
              WHEN todays_games.pos = 'C' THEN opponent_stats_by_pos.c_avg_fd
              END)
            FROM opponent_stats_by_pos
            WHERE opponent_stats_by_pos.team_name=todays_games.opponent;"
    end
    opponent_stats_by_pos

end

