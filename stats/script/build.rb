require 'pg'
require 'sequel'

#connect to db
DB=Sequel.connect(:adapter => 'postgres', :host => 'localhost', :database => 'stats_development')

def name 
#read getTables.rb script and creat table and data 
  tables=eval(File.read(File.expand_path("tables")))
  DB << "DROP TABLE IF EXISTS player" << "CREATE TABLE player (first VARCHAR(32), last VARCHAR(32), points VARCHAR(32), rebounds VARCHAR(32), assists VARCHAR(64), steals VARCHAR(64), blocks VARCHAR(64), turnovers VARCHAR(64))" 
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
		    puts "Inserting #{last}, #{first} into DB"
		  	xpoints=x[:points]
  			xrebounds=x[:rebounds]
  			xassists=x[:assists]
  			xsteals=x[:steals]
  			xblocks=x[:blocks]
  			xturnovers=x[:turnovers]
  	  DB << "INSERT INTO player (first, last, points, rebounds, assists, steals, blocks, turnovers) VALUES ('#{first}', '#{last}', '#{xpoints}', '#{xrebounds}', '#{xassists}', '#{xsteals}', '#{xblocks}', '#{xturnovers}')"
		  end
	end
end

name