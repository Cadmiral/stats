#!/usr/bin/ruby2.0.0

require 'sequel'
require 'pg'

# DB=Sequel.connect(:adapter => 'postgres', :host => 'localhost', :database => 'stats_development', :user=>'postgres', :password=>'pingpong21')

class NBAAlgorithm
	public
		def initialize
			@back2back = false
			@num_games_to_analyze = 10
			@position = "ALL"
			@result_array = Array.new
		end

		def run
			player_manager = NBAPlayerManager.new
			player_array = player_manager.getPlayerList
			doc = nil

			myCount = 0

			player_array.each{
				|player|

				# Filter on Position.
				if(player.getPosition.to_s != @position &&
					@position != 'ALL')
					next
				end


				# TODO: For Each player open GameLog HTML.

				playerName = player.getName
				# Remove '-' from name
				playerName.to_s.slice! "-"

				# Gather Player Info from HTML
				player_dataset = DB['SELECT * FROM boxscore WHERE player_name = ?', playerName.to_s]

				# Divide by 2, because redundant logs in html
				# Includes Basic and Advanced.
				total_games = player_dataset.count

				if(total_games > 0)
					# Prevent Out of bounds error.
					if(@num_games_to_analyze > total_games)
						num_games = total_games.to_f
					else
						num_games = @num_games_to_analyze.to_f
					end

					total_minutes = 0.0
					total_attempts = 0.0
					total_fg_percent = 0.0
					total_rebounds = 0.0
					total_assists = 0.0
					total_steals = 0.0
					total_blocks = 0.0
					total_turnovers = 0.0
					total_fouls = 0.0
					total_points = 0.0

					# TODO: Implement B2B Filter

					# Parse through the game logs for player.
					for index in 0...num_games
						# Reverse Index to get most recent games.

						reverse_index = total_games - (index + 1)

						# TODO: Need to convert to Time Data type.

						total_minutes += (player_dataset.map(:mins)[reverse_index].to_s.split(":")[0]).to_f
						total_attempts += player_dataset.map(:fg_attempt)[reverse_index].to_f
						total_fg_percent += player_dataset.map(:fg_percent)[reverse_index].to_f
						total_rebounds += player_dataset.map(:rebounds)[reverse_index].to_f
						total_assists += player_dataset.map(:assists)[reverse_index].to_f
						total_steals += player_dataset.map(:steals)[reverse_index].to_f
						total_blocks += player_dataset.map(:blocks)[reverse_index].to_f
						total_turnovers += player_dataset.map(:turnovers)[reverse_index].to_f
						total_fouls += player_dataset.map(:fouls)[reverse_index].to_f
						total_fouls = 0.0
						total_points += player_dataset.map(:points)[reverse_index].to_f
					end

					# Set NBAPlayer fields.
					avg_minutes = total_minutes/num_games
					avg_attempts = total_attempts/num_games
					avg_fg_percent = total_fg_percent/num_games
					avg_rebounds = total_rebounds/num_games
					avg_assists = total_assists/num_games
					avg_steals = total_steals/num_games
					avg_blocks = total_blocks/num_games
					avg_turnovers = total_turnovers/num_games
					avg_fouls = total_fouls/num_games
					avg_points = total_points/num_games

					# Populate Player Attributes
					player.setAvgMinutes(avg_minutes)
					player.setFGAttempts(avg_attempts)
					player.setFGPercentage(avg_fg_percent)
					player.setAvgRebounds(avg_rebounds)
					player.setAvgAssists(avg_assists)
					player.setAvgSteals(avg_steals)
					player.setAvgBlocks(avg_blocks)
					player.setAvgTurnovers(avg_turnovers)
					player.setAvgFouls(avg_fouls)
					player.setAvgPoints(avg_points)

					# TODO: Calculate Fantasy Value
					# STEAL_PTS = 2
					# BLOCK_PTS = 2
					# POINT_PTS = 1
					# REBOUND_PTS = 1.5
					# ASSIST_PTS = 1.2
					# FOUL_PTS = -1
					# TURNOVER_PTS = -1
					avgFantasyPoints = 0.0
					avgFantasyPoints += player.getAvgRebounds() * 1.5
					avgFantasyPoints += player.getAvgAssists() * 1.2
					avgFantasyPoints += player.getAvgSteals() * 2.0
					avgFantasyPoints += player.getAvgBlocks() * 2.0
					avgFantasyPoints += player.getAvgTurnovers() * -1.0
					avgFantasyPoints += player.getAvgFouls() * -1.0
					avgFantasyPoints += player.getAvgPoints() * 1.0
					player.setAvgFantasyPoints(avgFantasyPoints)

					# Set Fantasy Dollar per point Value.
					fantasyValue = "%2.2f" % ((avgFantasyPoints/player.getFantasySalary_FLOAT) *1000)
					player.setFantasyValue(fantasyValue.to_f)

					# DEBUG PRINT
					# puts "-----------------------------"
					# puts "-----------------------------"
					# puts player.getName
					# puts "Last " + num_games.to_i.to_s + " Games"
					# puts "-----------------------------"
					# puts "Avg Minutes: %5.2f" % avg_minutes
					# puts "Avg Attempts: %5.2f" % avg_attempts
					# puts "Avg FG Percent: %5.2f" % avg_fg_percent
					# puts "Avg Rebounds: %5.2f" % avg_rebounds
					# puts "Avg Assists: %5.2f" % avg_assists
					# puts "Avg Steals: %5.2f" % avg_steals
					# puts "Avg Blocks: %5.2f" % avg_blocks
					# puts "Avg Turnovers: %5.2f" % avg_turnovers
					# puts "Avg Fouls: %5.2f" % avg_fouls
					# puts "Avg Points: %5.2f" % avg_points
					# puts "Avg Fantasy Point: %5.2f" % avgFantasyPoints
					# puts "Avg Fantasy Value: %5.2f" % fantasyValue


					rating_system = RatingSystem.new
					rating1 = rating_system.getRating1(player)
					player.setRating1(rating1)

					@result_array.push(player)
					myCount += 1
				end
			}# end player interation for loop

			puts @position + " -- Count: " + myCount.to_s

			return @result_array

			# puts ""
			# for index in 0...@result_array.length
			# 	if(@result_array[index].getPosition == @position || @position == "ALL")
			# 		puts "-------------------------------"
			# 		print "%2s" % @result_array[index].getPosition + ": ";
			# 		print "%-25s" % @result_array[index].getName + " : ";
			# 		print "%7s" % @result_array[index].getFantasySalary_STR + " : ";
			# 		puts ""
			# 	end
			# end
			# puts "-------------------------------"
		end

		# Input:
		# => Boolean
		def setB2B(flag)
			if(flag == true || flag == false)
				@back2back = flag
			end
		end

		# Input:
		# => Interger - Number of most recent Games to calculate with.
		def setNumRecentGames(num_games)
			@num_games_to_analyze = num_games
		end

		# Input:
		# => String - PG, SG, SF, PF, C, ALL
		def setPosition(postion)
			@position = postion
		end

	private
		@back2back
		@num_games_to_analyze
		@position
		@result_array # Array of Players
end