
require 'pg'
require 'sequel'
require 'nokogiri'
require 'open-uri'

# where we are getting our Injury Info.
INJURY_URL = 'http://www.rotoworld.com/teams/injuries/nba/all/'

# Setup DB.
# DB=Sequel.connect(:adapter => 'postgres', :host => 'localhost', :database => 'stats_development', :user=>'postgres', :password=>'pingpong21')

class BuildNbaInjuryList
	def initialize
		puts "Creating table 'injury_list'..."
		# Drop and Create DB Table in postgres.
	    DB << "DROP TABLE IF EXISTS injury_list" << "CREATE TABLE injury_list (name VARCHAR (32), date DATE, team_name VARCHAR (32), injury VARCHAR(500), notes VARCHAR(500), status VARCHAR (100))"

	    # Scrape the Injury Data.
		doc = Nokogiri::HTML(open(INJURY_URL))

		injuries_html = doc.css('div#cp1_pnlInjuries').css('div.pb')

		teamsList = injuries_html.css('div.player')
		playerListPerTeam = injuries_html.css('table')

		# For Each Team.
		for teamIndex in 0...teamsList.length
			xteamName = teamsList[teamIndex].text.to_s

			# For Each Table of Players.
			for playerIndex in 0...playerListPerTeam[teamIndex].css('a').length/2

				# Player Name.
				xname = playerListPerTeam[teamIndex].css('a')[playerIndex*2].text
				xname.to_s.gsub!("'", '')
				xname.to_s.gsub!("-", '')
				xname.to_s.gsub!(".", '')
				xname.to_s.gsub!(" Jr", '')
				xname.to_s.gsub!(" III", '')

				# Injury Details.
				xdetails = playerListPerTeam[teamIndex].css('div.report')[playerIndex].text
				xdetails.to_s.gsub!("'", '')
				xdetails.to_s.gsub!(".", '')
				xdetails.to_s.gsub!("-", ' ')

				# Daily Status.
				xstatus = playerListPerTeam[teamIndex].css('div.impact')[playerIndex].text
				#xstatus.to_s.gsub!("-", ' ')

				# Position.
				xpos = playerListPerTeam[teamIndex].css('td')[9+playerIndex*7].text

				# Initial Injury Date.
				xdate = playerListPerTeam[teamIndex].css('td')[11+playerIndex*7].text + " 2014"
				xdate = Date.parse xdate

				# Injured Body Part.
				xinjury = playerListPerTeam[teamIndex].css('td')[12+playerIndex*7].text

				#Insert Scraped and Parsed Data Into DB table.
				DB << "INSERT INTO injury_list (name, date, team_name, injury, notes, status) VALUES ('#{xname}', '#{xdate}', '#{xteamName}', '#{xinjury}', '#{xdetails}', '#{xstatus}')"

			end
		end
	end
end # end of class

