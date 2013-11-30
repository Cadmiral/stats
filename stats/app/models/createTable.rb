require 'pg'
require 'sequel'

DB=Sequel.connect(:adapter => 'postgres', :host => 'localhost', :database => 'stats_development')

def createPlayerTable
  tables=eval(File.read(File.expand_path("../../../script/player_avg", __FILE__)))
  DB << "DROP TABLE IF EXISTS player" << "CREATE TABLE player (player_name VARCHAR(32) PRIMARY KEY, pos VARCHAR(32), team_name VARCHAR(32), points VARCHAR(32), rebounds VARCHAR(32), assists VARCHAR(64), steals VARCHAR(64), blocks VARCHAR(64), turnovers VARCHAR(64))" 
  tables.each do |x|
    xname=x[:name]
    
      if xname.chomp == ""
        tables.delete x
      else
        player = xname.split(/\s+/,2)
        stripfirst=player[0]
          first=stripfirst.tr("'","")
          striplast=player[1]
        last=striplast.tr("'","")
        puts "#{first} #{last}"
        # puts xname
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
# createPlayerTable

def createBoxscoreTable
    tables=eval(File.read(File.expand_path("../../../script/player_boxscore", __FILE__)))
    DB << "DROP TABLE IF EXISTS boxscore" << "CREATE TABLE boxscore (date VARCHAR(32), team_name VARCHAR (32), player_name VARCHAR(32),  opponent VARCHAR(32), mins VARCHAR(32), points VARCHAR(32), rebounds VARCHAR(32), assists VARCHAR(64), steals VARCHAR(64), blocks VARCHAR(64), turnovers VARCHAR(64))" 
    tables.each do |x|
      xname=x[:name]
      xdate=x[:date]
      xopponent=x[:opponent]
      xmins=x[:mins]
      xpoints=x[:points]
      xrebounds=x[:rebounds]
      xassists=x[:assists]
      xsteals=x[:steals]
      xblocks=x[:blocks]
      xturnovers=x[:turnovers]
      DB << "INSERT INTO boxscore (player_name, date, opponent, mins, points, rebounds, assists, steals, blocks, turnovers) VALUES ('#{xname}', '#{xdate}', '#{xopponent}', '#{xmins}', '#{xpoints}', '#{xrebounds}', '#{xassists}', '#{xsteals}', '#{xblocks}', '#{xturnovers}')"
    end
end
createBoxscoreTable
