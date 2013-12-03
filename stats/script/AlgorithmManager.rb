require 'nokogiri'
require 'open-uri'
require_relative 'NBAAlgorithm'
require_relative 'RatingSystem'
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
			@filtered_array = Array.new
			@num_output = 500
		end


		def runAlgorithm1
			# ************************************
			# * Description:
			# * 	Calculate using the 3 more recent games
			# ************************************

			# Algorithm Code here.
			algo1 = NBAAlgorithm.new
			algo1.setB2B(false) # not working yet
			algo1.setNumRecentGames(3) # works
			algo1.setPosition('PG') # works
			@filtered_array = algo1.run


			algo1.setPosition('SG') # works
			@filtered_array = algo1.run


			algo1.setPosition('SF') # works
			@filtered_array = algo1.run


			algo1.setPosition('PF') # works
			@filtered_array = algo1.run


			algo1.setPosition('C') # works
			@filtered_array = algo1.run
			# Print the Final List
			printPlayerList
		end

		# Input:
		# => Integer - number of players to print
		def setNumOutput(numOutput)
			@num_output = flag
		end

		def printPlayerList

			# TODO: Sort list on a Column

			number_of_printouts = 0

			if(@num_output > @filtered_array.length)
				number_of_printouts = @filtered_array.length
			else
				number_of_printouts = @num_output
			end

			puts "-------------------------------------------------------------------------------------------------------"
			print "%3s" % "POS" + " : ";
			print "%-25s" % "Player Name" + " : ";
			print "%7s" % "Salary" + " : ";
			print "%20s" % "Avg Fantasy Points" + " : ";
			print "%20s" % "Fantasy Value" + " : ";
			print "%10s" % "Rating1" + " : ";

			if(@filtered_array.length > 0)
				puts ""
				for index in 0...number_of_printouts
					if(@filtered_array[index].getAvgFantasyPoints > 20)
						puts "-------------------------------------------------------------------------------------------------------"
						print "%3s" % @filtered_array[index].getPosition + " : ";
						print "%-25s" % @filtered_array[index].getName + " : ";
						print "%7s" % @filtered_array[index].getFantasySalary_STR + " : ";
						print "%20.2f" % @filtered_array[index].getAvgFantasyPoints + " : ";
						print "%20.4f" % @filtered_array[index].getFantasyValue + " : ";
						print "%10s" % @filtered_array[index].getRating1.to_s + " : ";
						puts ""
					end
				end
			puts "-------------------------------------------------------------------------------------------------------"
			end
		end

	private
		@player_array
		@num_output

end