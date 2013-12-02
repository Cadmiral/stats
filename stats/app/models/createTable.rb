require 'pg'
require 'sequel'

DB=Sequel.connect(:adapter => 'postgres', :host => 'localhost', :database => 'stats_development')

def create_player_table
  tables=eval(File.read(File.expand_path("../../../script/player_avg", __FILE__)))
  DB << "DROP TABLE IF EXISTS player" << "CREATE TABLE player (player_name VARCHAR(32), pos VARCHAR(32), team_name VARCHAR(32), points DECIMAL, rebounds DECIMAL, assists DECIMAL, steals DECIMAL, blocks DECIMAL, turnovers DECIMAL)" 
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
  DB << "INSERT INTO player (player_name, pos, team_name, points, rebounds, assists, steals, blocks, turnovers) VALUES ('#{first} #{last}', '#{xpos}', '#{xteam}', '#{xpoints}', '#{xrebounds}', '#{xassists}', '#{xsteals}', '#{xblocks}', '#{xturnovers}')"
    end
  end
end
create_player_table


def create_boxscore_table
    tables=eval(File.read(File.expand_path("../../../script/player_boxscore", __FILE__)))
    DB << "DROP TABLE IF EXISTS boxscore" << "CREATE TABLE boxscore (date DATE, team_name VARCHAR (32), player_name VARCHAR(32),  home VARCHAR(32), opponent VARCHAR(32), mins VARCHAR(32), points INT, rebounds INT, assists INT, steals INT, blocks INT, turnovers INT)" 
    tables.each do |x|
      xname=x[:name]
      xdate=x[:date]
      xteam=x[:team]
      xhome=x[:home]
      xopponent=x[:opponent]
      xmins=x[:mins]
      xpoints=x[:points]
      xrebounds=x[:rebounds]
      xassists=x[:assists]
      xsteals=x[:steals]
      xblocks=x[:blocks]
      xturnovers=x[:turnovers]
      DB << "INSERT INTO boxscore (player_name, team_name, date, home, opponent, mins, points, rebounds, assists, steals, blocks, turnovers) VALUES ('#{xname}', '#{xteam}', '#{xdate}', '#{xhome}', '#{xopponent}', '#{xmins}', '#{xpoints}', '#{xrebounds}', '#{xassists}', '#{xsteals}', '#{xblocks}', '#{xturnovers}')"
    end
end
create_boxscore_table
