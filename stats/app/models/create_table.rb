require 'pg'
require 'sequel'

DB=Sequel.connect(:adapter => 'postgres', :host => 'localhost', :database => 'stats_development')

def create_player_table
  tables=eval(File.read(File.expand_path("../../../script/player_avg", __FILE__)))

  #***************************************
  #--------uncomment for first run------------
  #***************************************
  DB << "DROP TABLE IF EXISTS player" << "CREATE TABLE player (player_id SERIAL, player_name VARCHAR(32), pos VARCHAR(32), team_name VARCHAR(32), points DECIMAL, rebounds DECIMAL, assists DECIMAL, steals DECIMAL, blocks DECIMAL, turnovers DECIMAL)" 
  
  tables.each do |x|
    xname=x[:name]
      if xname.chomp == ""
        tables.delete x
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
        xpoints=x[:points]
        xrebounds=x[:rebounds]
        xassists=x[:assists]
        xsteals=x[:steals]
        xblocks=x[:blocks]
        xturnovers=x[:turnovers]
 
        #***************************************
        #--------uncomment for first run------------
        #***************************************
        DB << "INSERT INTO player (player_name, pos, team_name, points, rebounds, assists, steals, blocks, turnovers) VALUES ('#{first} #{last}', '#{xpos}', '#{xteam}', '#{xpoints}', '#{xrebounds}', '#{xassists}', '#{xsteals}', '#{xblocks}', '#{xturnovers}')"
      # DB << "UPDATE player SET (player_name, pos, team_name, points, rebounds, assists, steals, blocks, turnovers) = ('#{first} #{last}', '#{xpos}', '#{xteam}', '#{xpoints}', '#{xrebounds}', '#{xassists}', '#{xsteals}', '#{xblocks}', '#{xturnovers}') WHERE player_name = '#{first} #{last}'"    
    end

    #remove duplicate player entries
    DB << "DELETE FROM player WHERE player_id IN (SELECT player_id FROM (SELECT player_id, row_number() over (partition BY player_name ORDER BY player_id) AS rnum FROM player) t WHERE t.rnum > 1)"
    #resequence player_id after removing players
    DB << "ALTER TABLE player DROP player_id; ALTER TABLE player ADD player_id SERIAL PRIMARY KEY"
    #change these players position and add team name
    DB << "UPDATE player SET pos='SF', team_name='SAC' WHERE player_name='Derrick Williams'; UPDATE player SET pos='PF', team_name='MIN' WHERE player_name='Luc MbahaMoute'"
  end
end
create_player_table


def create_boxscore_table
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
      if xfg_percent == ""
        then xfg_percent = "0"
      end
      xrebounds=x[:rebounds]
      xassists=x[:assists]
      xsteals=x[:steals]
      xblocks=x[:blocks]
      xturnovers=x[:turnovers]
      xfouls=x[:fouls]
      DB << "INSERT INTO boxscore (player_name, team_name, date, home, opponent, mins, points, fg_attempts, fg_percent, rebounds, assists, steals, blocks, turnovers, fouls) VALUES ('#{xname}', '#{xteam}', '#{xdate}', '#{xhome}', '#{xopponent}', '#{xmins}', '#{xpoints}', '#{xfg_attempts}', '#{xfg_percent}', '#{xrebounds}', '#{xassists}', '#{xsteals}', '#{xblocks}', '#{xturnovers}', '#{xfouls}')"
    end
    DB << "UPDATE boxscore SET player_id = player.player_id FROM player where player.player_name = boxscore.player_name"
end
create_boxscore_table
