#!/usr/bin/ruby2.0.0
require 'pg'
require 'sequel'
require 'nokogiri'
require 'open-uri'

unless defined? DB
	# Setup DB Connector.
	puts " TodaysGameScraper.rb: Define DB Connector"
	DB=Sequel.connect(:adapter => 'postgres', :host => '174.129.141.105', :database => 'stats_development', :user=>'postgres', :password=>'pingpong21')
end

unless defined? LASTUPDATE_FILENAME
	# Filename to keep track of when we last ran the
	# script to get the boxscore.  (Script takes 5 min)
	LASTUPDATE_FILENAME = "lastupdated.txt"
end

class TodaysGameScraper
	def initialize
		# Do nothing for now.
	end # end initialize

	# Scrape Scrape Scrape.
	def scrapeAndPopulate
		puts "\nBEGIN: Getting Today's Games Boxscore Statistics..."
		# Read to see when we last updated today's game.
		readLastUpdatedFileLog

		util = Utilities.new
		count = 1
		gameId = 400489223
		date_of_game = nil
		logFlag = false

		while(1)
			gameStatsHTML = "http://scores.espn.go.com/nba/boxscore?gameId=" + gameId.to_s
			doc = Nokogiri::HTML(open(gameStatsHTML))
			date = doc.css("p")[7].text
			date_of_game = Date.parse(date)

			# SNF TODO: Implement This.
			# if(@todays_game_updated_date >= date_of_game)
			# 	# We are up to date. GTFO!
			# 	break
			# end

			if(Time.now < Time.parse(Date.today.to_s)+ 9*60*60)
				date_of_latest_game = Date.today - 1
			else

			end

			if(date_of_game < Date.today)
				# If not today, go to the next game.
				gameId += 1
				next
			elsif(date_of_game == Date.today)
				# These are today's stats.
				# Get Today's Day as a Time Object.
				today_day_time = Time.now.strftime("%d/%m/%Y")
				# Today when stats got updated.
				# ASSUMING STATS ARE UPDATED BY 10:30 pmeveryday.
				today_update_time = Time.parse(today_day_time) +  22*60*60 + 30*60

				if(Time.now < today_update_time)
					# Break out of loop because this game has not finish being played.
					puts "TODAY's Stats not ready."
					break
				end
			else
				break
			end

			if(doc.css("tbody").count < 4)
				# Loop till we get to an game with no stats.
				break
			end

			for tableIndex in [0, 1, 3, 4]
				playerTable = doc.css("tbody")[tableIndex]

				# Did not play indexing.
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
					name.to_s.gsub!("'", '')
					name.to_s.gsub!("-", '')
					name.to_s.gsub!(".", '')
					name.to_s.gsub!(" Jr", '')
					name.to_s.gsub!(" III", '')

					if(playerTable.css("td")[index+1].text.include? "DNP")
						# Did not Play. Set all stats to zero.
						mins = 0
						fg_made = 0
						fg_attempts = 0
						fg_percent = 0.0
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
						fg_made =  fgm_a[0].to_i
						fg_attempts = fgm_a[1].to_i
						if(fg_made == 0)
							fg_percent = 0.0
						else
							fg_percent = fg_made.to_f/fg_attempts.to_f
						end

						rebounds = playerTable.css("td")[index+7].text
						assists = playerTable.css("td")[index+8].text
						steals = playerTable.css("td")[index+9].text
						blocks = playerTable.css("td")[index+10].text
						turnovers = playerTable.css("td")[index+11].text
						fouls = playerTable.css("td")[index+12].text
						points = playerTable.css("td")[index+14].text

						fd_points = util.getFanDuelPoints(points.to_f,
														rebounds.to_f,
														assists.to_f,
														blocks.to_f,
														steals.to_f,
														turnovers.to_f)
					end

					# TODO: Update DB
					# Match player_name and date and enter stats.
					date_db_format = date_of_game.strftime("%Y-%m-%d").to_s
					# puts date_db_format
					# puts name
					# puts fg_made
					# puts fg_attempts
					# puts fg_percent

					print "\r" + date_of_game.to_s + ": " + gameId.to_s + "Count: %d" % count.to_s
		            count += 1
					DB << "UPDATE todays_game_stats
							SET mins = '#{mins}',
		                        points = #{points},
		                        fg_attempts = #{fg_attempts},
		                        fg_percent = #{fg_percent},
		                        rebounds = #{rebounds},
		                        assists = #{assists},
		                        steals = #{steals},
		                        blocks = #{blocks},
		                        turnovers = #{turnovers},
		                        fouls = #{fouls},
		                        fd_points = #{fd_points}
						WHERE todays_game_stats.date = '#{date_db_format}'
						AND todays_game_stats.player_name = '#{name}'"

					#puts name
					#puts points
				end # Loop through each player's row.
			end # Loop through four player's tables.
			print ": DONE\n"
			count = 1
			# Increment to the next game boxscore.
			gameId = gameId + 1
			logFlag = true
		end # Infinite While.

		if(logFlag)
			# Log what we just updated.
			writeLastUpdatedFileLog(date_of_game)
		end

		puts "DONE: Getting Today's Games Boxscore Statistics..."
	end # End run

	private
		@todays_game_updated_date

		def writeLastUpdatedFileLog(date)
			# Read the Dictionary in the file.
			file = File.open(LASTUPDATE_FILENAME, 'r')
			file_data = file.gets
			# Note: eval() is a huge security risk.  Do not use if user input can ever effect string input.
			file_dict = eval(file_data)

			# Only Update the field(s) that is/are applicable.
			file = File.open(LASTUPDATE_FILENAME, 'w')
			file_dict["todays_game_updated_date"] = date.to_s
			file.write(file_dict)

			file.close
		end # logTodaysSalariesUpdate

		def readLastUpdatedFileLog
			# Read the last time we ran the salary scrape.
			file = File.open(LASTUPDATE_FILENAME, 'r')
			file_data = file.gets
			# Note: eval() is a huge security risk.  Do not use if user input can ever effect string input.
			file_hash = eval(file_data)

			if(file_hash.has_key?("todays_game_updated_date"))
				# Set the date from the file.
				@todays_game_updated_date = file_hash['todays_game_updated_date']
			else
				# Set to zero because we have never scraped.
				@todays_game_updated_date = Date.new(2001,1,1)
			end
			file.close
		end
end # End Class