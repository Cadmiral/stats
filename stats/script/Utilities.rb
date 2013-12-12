

class Utilities

	def getTeamAbbr(teamName_string)
		teamAbbrList =
		{
			"Boston Celtics" => "BOS",
			"Brooklyn Nets" => "BKN",
			"New York Knicks" => "NYK",
			"Philadelphia 76ers" => "PHI",
			"Toronto Raptors" => "TOR",
			"Golden State Warriors" => "GSW",
			"Los Angeles Clippers" => "LAC",
			"Los Angeles Lakers" => "LAL",
			"Phoenix Suns" => "PHO",
			"Sacramento Kings" => "SAC",
			"Chicago Bulls" => "CHI",
			"Cleveland Cavaliers" => "CLE",
			"Detroit Pistons" => "DET",
			"Indiana Pacers" => "IND",
			"Milwaukee Bucks" => "MIL",
			"Dallas Mavericks" => "DAL",
			"Houston Rockets" => "HOU",
			"Memphis Grizzlies" => "MEM",
			"New Orleans Pelicans" => "NOP",
			"San Antonio Spurs" => "SAS",
			"Atlanta Hawks" => "ATL",
			"Charlotte Bobcats" => "CHA",
			"Miami Heat" => "MIA",
			"Orlando Magic" => "ORL",
			"Washington Wizards" => "WAS",
			"Denver Nuggets" => "DEN",
			"Minnesota Timberwolves" => "MIN",
			"Oklahoma City Thunder" => "OKC",
			"Portland Trail Blazers" => "POR",
			"Utah Jazz" => "UTA"
		}

        return teamAbbrList[teamName_string]
	end

end

begin
	util = Utilities.new
	if(util.getTeamAbbr("Boba"))
		puts "FOUND"
	else
		puts "NOT FOUND"
	end


end