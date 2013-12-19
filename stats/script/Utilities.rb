

class Utilities

	def initialize
		puts "Initialize Utilities..."
	end

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

	def getFanDuelPoints(points, rebounds, assists, blocks, steals, turnovers)
		# 3-pt FG = 3pts
		# 2-pt FG = 2pts
		# FT = 1pt
		# Rebound = 1.2pts
		# Assist = 1.5pts
		# Block = 2pts
		# Steal = 2pts
		# Turnover = -1pt
		fantasy_points = points + rebounds*1.2 +  assists*1.5 + blocks*2 + steals*2 - turnovers

		return fantasy_points
	end

end