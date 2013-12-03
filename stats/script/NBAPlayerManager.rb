
require 'nokogiri'
require 'open-uri'
require_relative 'NBAPlayer'

class NBAPlayerManager

	public
		def initialize
			@nbaplayer_array = Array.new
			buildNBAPLayerList
		end

		def runTest
			puts @nbaplayer_array[0].getName + @nbaplayer_array[0].getFantasySalary_STR
			puts @nbaplayer_array[1].getName + @nbaplayer_array[1].getFantasySalary_STR
			puts @nbaplayer_array[2].getName + @nbaplayer_array[2].getFantasySalary_STR
		end # end runTest

		def getPlayerList
			return @nbaplayer_array
		end
	private
		# Array of NBA Injuries
		@nbaplayer_array

		# Input:
		# =>  None.
		# Output:
		# =>  None
		def buildNBAPLayerList
			doc = Nokogiri::HTML(open('fanduel_salarylist_Nov29.html'))
			# <table class="condensed player-list-table"

			player_table = doc.css('table.condensed')[2].css('tbody').css('tr')
			for index in 0...player_table.length
				position = player_table[index].css('td')[0].text
				name = player_table[index].css('td')[1].text
				fantasy_salary = player_table[index].css('td')[5].text

				player = NBAPlayer.new(name, position, fantasy_salary)
				@nbaplayer_array.push(player)
			end

			puts "Player List Length : " + @nbaplayer_array.length.to_s
		end # end buildInjuriesList
end

