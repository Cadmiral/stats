
require 'nokogiri'
require 'open-uri'
require_relative 'NBAPlayerManager'

# Notes:
#
# Time

# 1) Last 5 Games played.

# 2) Back to Back Games

# Catagories
# 1)

# 2) Allowed Points by a Team

# 3) Starter Injured on Opposing Team

# 4) Points Per Dollar

# 5) Point Value Per Position

# Alert

# 1) Coming back from injury

# 2) Top 10 Defensive Team Yellow
#	 Top 5  Defensive Team Red

# 3)

# Example
#     Stats for last 5 back to back games.
#     Stats for the last 5 games.

class AlgorithmManager

	public
		def initialize
			@back2back = false
			@num_games = 10
			@position = "ALL"
			@filtered_array = Array.new
			@num_output = 20
		end

		def runAlgorithm
			# Populate Player Array
			playerManager = NBAPlayerManager.new
			@filtered_array = playerManager.getPlayerList


			printPlayerList
		end

		# Input:
		# => Boolean
		def setB2B(flag)
			if(flag == true || flag == false)
				@back2back = flag
			end
		end

		# Input:
		# => Interger - Number of recent Games.
		def setNumRecentGames(num_games)
			@back2back = num_games
		end

		# Input:
		# => String - PG, SG, SF, PF, C, ALL
		def setPosition(flag)
			@back2back = flag
		end

		# Input:
		# => Integer - number of players to print
		def setNumOutput(numOutput)
			@num_output = flag
		end

		def printPlayerList
			puts ""
			for index in 0...@num_output
				if(@filtered_array[index].getPosition == @position || @position == "ALL")
					puts "-------------------------------"
					print "%2s" % @filtered_array[index].getPosition + ": ";
					print "%-25s" % @filtered_array[index].getName + " : ";
					print "%7s" % @filtered_array[index].getFantasySalary + " : ";
					puts ""
				end
			end
			puts "-------------------------------"
		end

	private
		@back2back
		@num_games
		@position
		@player_array
		@num_output

end