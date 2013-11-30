#!/usr/bin/ruby2.0.0


class NBAPlayer
	public
	    # Populate the Object.
	    def initialize(name, fantasy_salary)
	    	@name = name
	    	@fantasy_salary = fantasy_salary
	    end

	    # Accessor Functions.
	    def getName
	      	return @name
	    end

	    def getFantasySalary
	      	return @fantasy_salary
	    end


	    def setPosition(position)
			@position = position
	    end

	    def getPosition
			return @position
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

	    def setAvgTurnovers(avg_turnovers)
			@avg_turnovers = avg_turnovers
	    end

	    def getAvgTurnovers
			return @avg_turnovers
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

	    def setFantasyValue(fantasy_value)
			@fantasy_value = fantasy_value
	    end

	    def getFantasyValue
			return @fantasyValue
	    end

    private
    	@name
    	@position
    	@fantasy_salary
    	@fg_percentage
    	@avg_points
		@avg_assists
		@avg_rebounds
		@avg_steals
    	@avg_turnovers
    	@avg_minutes
    	@notes
    	@fantasyValue
end