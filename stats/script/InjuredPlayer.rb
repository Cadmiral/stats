#!/usr/bin/ruby2.0.0


 class InjuredPlayer
    # Populate the Object.
    def initialize(id, name, injury, dateOfInjury, status, position, details, team)
		@id = id
        @name = name
	    @injury = injury
	    @dateOfInjury = dateOfInjury
	    @status = status
	    @position = position
	    @details = details
	    @team = team
    end

    # Accessor Functions.
    def getName
      	return @name
    end

    def getDateOfInjury
      	return @dateOfInjury
    end

    def getInjury
      	return @injury
    end

    def getPosition
      	return @position
    end

    def getDetails
      	return @details
    end

    def getTeam
		return @team
    end

    def getStatus
		return @status
    end

    private
    @id
    @name
    @injury
    @dateOfInjury
    @status
    @position
    @details
    @team


  end
