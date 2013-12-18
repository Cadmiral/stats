#!/usr/bin/ruby2.0.0
require 'pg'
require 'sequel'
require 'nokogiri'
require 'open-uri'

class TodaysGameScraper

	# We just run on initialize.
	def initialize
		gameId = 400489223

		while(1)
			gameStatsHTML = "http://scores.espn.go.com/nba/boxscore?gameId=" + gameId.to_s
			doc = Nokogiri::HTML(open(gameStatsHTML))
			date = doc.css("p")[7].text
			puts date

			if(doc.css("tbody").count < 4)
				# Loop till we get to an game with no stats.
				break
			end

			for tableIndex in [0, 1, 3, 4]
				playerTable = doc.css("tbody")[tableIndex]
				dnpIndexing = false
				for playerIndex in 0...playerTable.css("a").count
					if(dnpIndexing)
						# DNP players don't have stats, so adjust indexing.
						index = index + 2
					else
						# Jump to next player's stats
						index = 15 * playerIndex
					end

					name = playerTable.css("a")[playerIndex].text

					if(playerTable.css("td")[index+1].text.include? "DNP")
						# Did not Play. Set all stats to zero.
						mins = 0
						fg_made = 0
						fg_attempts = 0
						rebounds = 0
						assists = 0
						steals = 0
						blocks = 0
						turnovers = 0
						fouls = 0
						points = 0
						dnpIndexing = true
					else
						# Extract player's stats.
						mins = playerTable.css("td")[index+1].text

						fgm_a = playerTable.css("td")[index+2].text
						fgm_a = fgm_a.split('-')
						fg_made =  fgm_a[0]
						fg_attempts = fgm_a[1]

						rebounds = playerTable.css("td")[index+7].text
						assists = playerTable.css("td")[index+8].text
						steals = playerTable.css("td")[index+9].text
						blocks = playerTable.css("td")[index+10].text
						turnovers = playerTable.css("td")[index+11].text
						fouls = playerTable.css("td")[index+12].text
						points = playerTable.css("td")[index+14].text
					end

					# TODO: Update DB
					# Match player_name and date and enter stats.
					puts name
					puts points

				end # Loop through each player's row.
			end # Loop through four player's tables.

			# Increment to the next game boxscore.
			gameId = gameId + 1
		end # Infinite While.
	end # End initialize
end # End Class

begin
	#TodaysGameScraper.new
	LASTUPDATE_FILENAME = "testFile.txt"

	# Update the file that tells us when we late updated.
	file = File.open(LASTUPDATE_FILENAME, 'w')
	now_time = Time.now.strftime("%m/%d/%Y %H:%M")
	myHash = {"boxscore_lastupdate" => now_time, "lastGameId" => 400489190}
	file.write(myHash)
	file.close

	# Read the last time we ran the update box script.
	file = File.open(LASTUPDATE_FILENAME, 'r')
	file_data = file.gets
	# Note: eval() is a huge security risk.  Do not use if user input can ever effect string input.
	foo = eval(file_data)

	puts foo.class
	puts foo['boxscore_lastupdate']
	file.close

end








