#!/usr/bin/ruby2.0.0

class RatingSystem

	# Input
	# =>  NBAPlayer object
	def getRating1(player)
		rating = 0;

		if(player.getAvgRebounds > 7)
			rating += 3
		elsif(player.getAvgRebounds > 4)
			rating += 2
		end

		if(player.getAvgAssists > 7)
			rating += 3
		elsif(player.getAvgAssists > 4)
			rating += 2
		end

		if(player.getAvgSteals > 1)
			rating += 2
		end

		if(player.getAvgBlocks > 1)
			rating += 2
		end

		# if(player.getAvgTurnovers)
		# elsif(player.getAvgTurnovers)
		# end

		if(player.getAvgFouls > 3)
			rating -= 2
		end

		if(player.getAvgPoints > 20)
			rating += 4
		elsif(player.getAvgPoints > 15)
			rating += 3
		elsif(player.getAvgPoints > 10)
			rating += 2
		end

		if(player.getFGAttempts > 13)
			rating += 3
		elsif(player.getFGAttempts > 9)
			rating += 2
		end

		# if(player.getFGPercentage > .500)
		# elsif(player.getFGPercentage)
		# end


		if(player.getAvgMinutes > 30)
			rating += 3
		elsif(player.getAvgMinutes > 20)
			rating += 2
		end


		if(player.getAvgFantasyPoints > 40)
			rating += 4
		elsif(player.getAvgFantasyPoints > 30)
			rating += 3
		elsif(player.getAvgFantasyPoints > 20)
			rating += 2
		elsif(player.getAvgFantasyPoints > 15)
			rating += 1
		end

		# if(player.getFantasyValue > 3.5)
		# 	rating += 2
		# elsif(player.getFantasyValue > 3.2)
		# 	rating += 1
		# end

		return rating
	end

end