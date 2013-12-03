#!/usr/bin/ruby2.0.0

require 'nokogiri'
require 'open-uri'
require_relative 'InjuredPlayer'

class InjuryManager

	public
		def initialize
			@injured_player_array = Array.new
			buildInjuriesList
		end

		# Input:
		# =>  String - Player Name.
		# Output:
		# =>  Boolean
		def isPlayerInjured(playerName)
			@injured_player_array.each{
				|player|
				if player.getName == playerName
					return true
				end
			}

			return false
		end # end isPlayerInjured

		# Input:
		# =>  String - Player Name.
		# Output:
		# =>  "InjuredPlayer" Object.
		def getInjuryData(playerName)
			data = nil;

			@injured_player_array.each{
				|player|
				if player.getName == playerName
					return player
				end
			}

			return data
		end # end getInjuryData


		# Input:
		# =>  Array of Player Names.
		# Output:
		# =>  Array of "InjuredPlayer" objects.
		def checkTeamForInjuries(playerNameList)
			injuryPlayers = Array.new

			for playerIndex in 0...playerNameList.length
				if(isPlayerInjured(playerNameList[playerIndex]))
					data = getInjuryData(playerNameList[playerIndex])
					injuryPlayers.push(data)
				end
			end

			return injuryPlayers
		end

		# Unit Test
		def runTest
			puts "------- START INJURED PLAYER TEST --------"

			#myTeam = ["Shaun Livingston", "Keith Bogans", "Steven Funasaki"];
			myTeam = ["Nate Robinson",
						"John Wall",
						"Rodney Stuckey",
						"James Anderson",
						"Khris Middleton",
						"Martell Webster",
						"Anthony Davis",
						"Serge Ibaka",
						"Andrew Bogut",
						"Michael Carter-Williams",
						"Goran Dragic",
						"Rodney Stuckey",
						"Thabo Sefolosha",
						"Martell Webster",
						"Michael Beasley",
						"Anthony Davis",
						"Channing Frye",
						"Andre Drummond"]

			injuredPlayers = checkTeamForInjuries(myTeam);

			for index in 0...injuredPlayers.length
				print injuredPlayers[index].getName + " --- "
				print injuredPlayers[index].getInjury + " --- "
				print injuredPlayers[index].getStatus
				print "\n"
			end

			puts "------- END INJURED PLAYER TEST --------"
		end # end runTest

		def removeInjuredPlayers(player_array)
			player_array.each{
				|player|

				if player.getName == playerName
					return true
				end
			}

			return false
		end # end isPlayerInjured		end

	private
		# Array of NBA Injuries
		@injured_player_array


		# Input:
		# =>  None.
		# Output:
		# =>  None
		def buildInjuriesList
			#doc = Nokogiri::HTML(open('http://www.rotoworld.com/teams/injuries/nba/all/'))
			doc = Nokogiri::HTML(open('output.html'))

			injuries_html = doc.css('div#cp1_pnlInjuries').css('div.pb')

			teamsList = injuries_html.css('div.player')
			playerListPerTeam = injuries_html.css('table')

			#For Each Team
			for teamIndex in 0...teamsList.length

				# For Each Table of Players
				for playerIndex in 0...playerListPerTeam[teamIndex].css('a').length/2

					name = playerListPerTeam[teamIndex].css('a')[playerIndex*2].text
					details = playerListPerTeam[teamIndex].css('div.report')[playerIndex].text
					status = playerListPerTeam[teamIndex].css('div.impact')[playerIndex].text
					pos = playerListPerTeam[teamIndex].css('td')[9+playerIndex*7].text
					date = playerListPerTeam[teamIndex].css('td')[11+playerIndex*7].text
					injury = playerListPerTeam[teamIndex].css('td')[12+playerIndex*7].text

					# Query DB to get Player id.
					id = 0

					player = InjuredPlayer.new(id, name, injury, date, status, pos, details, teamsList[teamIndex].text)
					@injured_player_array.push(player)
				end
			end
		end # end buildInjuriesList
end

