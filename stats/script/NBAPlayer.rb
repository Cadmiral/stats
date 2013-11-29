#!/usr/bin/ruby2.0.0


class NBAPlayer
	public
	    # Populate the Object.
	    def initialize(name,
	    				fg_percentage,
	    				avg_points,
	    				avg_assists,
	    				avg_rebounds,
	    				avg_steals,
				    	avg_turnovers,
				    	avg_minutes)
			@name = name
	    	@fg_percentage = fg_percentage
	    	@avg_points = avg_points
			@avg_assists = avg_assists
			@avg_rebounds = avg_rebounds
			@avg_steals = avg_steals
	    	@avg_turnovers = avg_turnovers
	    	@avg_minutes = avg_minutes
	    end

	    # Accessor Functions.
	    def getName
	      	return @name
	    end

	    def getFGPercentage
	      	return @fg_percentage
	    end

	    def getAvgPoints
	      	return @avg_points
	    end

	    def getAvgAssists
	      	return @avg_assists
	    end

	    def getAvgRebounds
	      	return @avg_rebounds
	    end

	    def getAvgSteals
			return @avg_steals
	    end

	    def getAvgTurnovers
			return @avg_turnovers
	    end

	    def getAvgMinutes
			return @avg_minutes
	    end

    private
    	@name
    	@fg_percentage
    	@avg_points
		@avg_assists
		@avg_rebounds
		@avg_steals
    	@avg_turnovers
    	@avg_minutes

end