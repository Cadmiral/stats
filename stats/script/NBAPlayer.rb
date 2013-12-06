#!/usr/bin/ruby2.0.0


class NBAPlayer
	public
	    # Populate the Object.
	    def initialize(id, name, position, fantasy_salary)
	    	@id = id
	    	@name = name
	    	@position = position
	    	@fantasy_salary = fantasy_salary
	    end

	    # Accessor Functions.
	    def getName
	      	return @name
	    end

	    def getPosition
			return @position
	    end

	    def getFantasySalary_STR
	      	return @fantasy_salary
	    end

	    def getFantasySalary_FLOAT
	    	# TODO: Do this right.

	    	# Take off $
	    	temp = @fantasy_salary.split("$")
	    	temp = temp[1]
	    	# Take off ,
	    	temp = temp.split(',')

	    	final = temp[0] + temp[1]

	      	return final.to_f
	    end

	    def setFGAttempts(fg_attempts)
		    @fg_attempts = fg_attempts
	    end

	    def getFGAttempts
	      	return @fg_attempts
	    end

	    def setFGPercentage(fg_percentage)
		    @fg_percentage = fg_percentage
	    end

	    def getFGPercentage
	      	return @fg_percentage
	    end

	    def setAvgPoints(avg_points)
	      	@avg_points = avg_points
	    end

	    def getAvgPoints
	      	return @avg_points
		end

		def setAvgAssists(avg_assists)
	    	@avg_assists = avg_assists
	    end

	    def getAvgAssists
	      	return @avg_assists
	    end

	    def setAvgRebounds(avg_rebounds)
	      	@avg_rebounds = avg_rebounds
	    end
	    def getAvgRebounds
	      	return @avg_rebounds
	    end

	    def setAvgSteals(avg_steals)
			@avg_steals = avg_steals
	    end

	    def getAvgSteals
			return @avg_steals
	    end

	    def setAvgBlocks(avg_blocks)
			@avg_blocks = avg_blocks
	    end

	    def getAvgBlocks
			return @avg_blocks
	    end

	    def setAvgTurnovers(avg_turnovers)
			@avg_turnovers = avg_turnovers
	    end

	    def getAvgTurnovers
			return @avg_turnovers
	    end

	    def setAvgFouls(avg_fouls)
			@avg_fouls = avg_fouls
	    end

	    def getAvgFouls
			return @avg_fouls
	    end

	    def setAvgMinutes(avg_minutes)
			@avg_minutes = avg_minutes
	    end

	    def getAvgMinutes
			return @avg_minutes
	    end

	    def setNotes(notes)
			@notes = notes
	    end

	    def getNotes
			return @notes
	    end

	    def setAvgFantasyPoints(avg_fantasy_points)
			@avg_fantasy_points = avg_fantasy_points
	    end

	    def getAvgFantasyPoints
			return @avg_fantasy_points
	    end

	    def setFantasyValue(fantasy_value)
			@fantasy_value = fantasy_value
	    end

	    def getFantasyValue
			return @fantasy_value
	    end

	    def setRating1(rating1)
			@rating1 = rating1
	    end

	    def getRating1
			return @rating1
	    end

	    def setOpponent(opponent)
			@opponent = opponent
	    end

	    def getOpponent
			return @opponent
	    end

	    def setOpponentDefRank(opponent)
			@opponentDefRank = opponentDefRank
	    end

	    def getOpponentDefRank
			return @opponentDefRank
	    end
    private
    	@id
    	@name
    	@position
    	@fantasy_salary
    	@fg_attempts
    	@fg_percentage
    	@avg_points
		@avg_assists
		@avg_rebounds
		@avg_steals
		@avg_blocks
    	@avg_turnovers
    	@avg_fouls
    	@avg_minutes
    	@notes
    	@fantasy_value
    	@avg_fantasy_points
    	@rating1
    	@opponent
    	@opponentDefRank
end