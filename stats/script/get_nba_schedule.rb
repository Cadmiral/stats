require 'nokogiri'
require 'open-uri'

class GetNBASchedule
    def initialize
        #delete boxscore file if already exists
        if File.exists?("nba_schedule")
            File.delete("nba_schedule")
        end

    #get data from bball-refernce
        doc = Nokogiri::HTML(open("http://www.basketball-reference.com/leagues/NBA_2015_games.html"))
        rows = doc.xpath('//table[@id="games"]/tbody/tr') 
        details = rows.collect do |row|
          detail = {}
              [
                [:date, 'td[1]/a/text()'],
                [:team, 'td[3]/a/text()'],
                [:team_score, 'td[4]/text()'],
                [:opponent, 'td[5]/a/text()'],
                [:opponent_score, 'td[6]/text()']
              ].each do |name, xpath|
              detail[name] = row.at_xpath(xpath).to_s.strip
              end
        detail
        end

    #change team names to match db
        details.each{|key| case key[:team]
            when "Atlanta Hawks"
                key[:team] = "ATL"
            when "Boston Celtics"
                key[:team] = "BOS"
            when "Brooklyn Nets"
                key[:team] = "BRK"
            when "Charlotte Hornets"
                key[:team] = "CHO"        
            when "Chicago Bulls"
                key[:team] = "CHI"
            when "Cleveland Cavaliers"
                key[:team] = "CLE"
            when "Dallas Mavericks"
                key[:team] = "DAL"
            when "Denver Nuggets"
                key[:team] = "DEN"
            when "Detroit Pistons"
                key[:team] = "DET"
            when "Golden State Warriors"
                key[:team] = "GSW"
            when "Houston Rockets"
                key[:team] = "HOU"
            when "Indiana Pacers"
                key[:team] = "IND"
            when "Los Angeles Clippers"
                key[:team] = "LAC"
            when "Los Angeles Lakers"
                key[:team] = "LAL"
            when "Memphis Grizzlies"
                key[:team] = "MEM"
            when "Miami Heat"
                key[:team] = "MIA"
            when "Milwaukee Bucks"
                key[:team] = "MIL"
            when "Minnesota Timberwolves"
                key[:team] = "MIN"
            when "New Orleans Pelicans"
                key[:team] = "NOP"
            when "New York Knicks"
                key[:team] = "NYK"
            when "Oklahoma City Thunder"
                key[:team] = "OKC"
            when "Orlando Magic"
                key[:team] = "ORL"
            when "Boston Celtics"
                key[:team] = "BOS"
            when "Philadelphia 76ers"
                key[:team] = "PHI"
            when "Phoenix Suns"
                key[:team] = "PHO"
            when "Portland Trail Blazers"
                key[:team] = "POR"
            when "Sacramento Kings"
                key[:team] = "SAC"
            when "San Antonio Spurs"
                key[:team] = "SAS"
            when "Toronto Raptors"
                key[:team] = "TOR"
            when "Utah Jazz"
                key[:team] = "UTA"
            when "Washington Wizards"
                key[:team] = "WAS"
        end
        }
        details.each{|key| case key[:opponent]
            when "Atlanta Hawks"
                key[:opponent] = "ATL"
            when "Boston Celtics"
                key[:opponent] = "BOS"
            when "Brooklyn Nets"
                key[:opponent] = "BRK"
            when "Charlotte Hornets"
                key[:opponent] = "CHO"        
            when "Chicago Bulls"
                key[:opponent] = "CHI"
            when "Cleveland Cavaliers"
                key[:opponent] = "CLE"
            when "Dallas Mavericks"
                key[:opponent] = "DAL"
            when "Denver Nuggets"
                key[:opponent] = "DEN"
            when "Detroit Pistons"
                key[:opponent] = "DET"
            when "Golden State Warriors"
                key[:opponent] = "GSW"
            when "Houston Rockets"
                key[:opponent] = "HOU"
            when "Indiana Pacers"
                key[:opponent] = "IND"
            when "Los Angeles Clippers"
                key[:opponent] = "LAC"
            when "Los Angeles Lakers"
                key[:opponent] = "LAL"
            when "Memphis Grizzlies"
                key[:opponent] = "MEM"
            when "Miami Heat"
                key[:opponent] = "MIA"
            when "Milwaukee Bucks"
                key[:opponent] = "MIL"
            when "Minnesota Timberwolves"
                key[:opponent] = "MIN"
            when "New Orleans Pelicans"
                key[:opponent] = "NOP"
            when "New York Knicks"
                key[:opponent] = "NYK"
            when "Oklahoma City Thunder"
                key[:opponent] = "OKC"
            when "Orlando Magic"
                key[:opponent] = "ORL"
            when "Boston Celtics"
                key[:opponent] = "BOS"
            when "Philadelphia 76ers"
                key[:opponent] = "PHI"
            when "Phoenix Suns"
                key[:opponent] = "PHO"
            when "Portland Trail Blazers"
                key[:opponent] = "POR"
            when "Sacramento Kings"
                key[:opponent] = "SAC"
            when "San Antonio Spurs"
                key[:opponent] = "SAS"
            when "Toronto Raptors"
                key[:opponent] = "TOR"
            when "Utah Jazz"
                key[:opponent] = "UTA"
            when "Washington Wizards"
                key[:opponent] = "WAS"
        end
        }

        #change empty percent strings to '0'
        details.each{|key| case key[:team_score]
            when ""
                key[:team_score] = "0"
        end
        }   
        details.each{|key| case key[:opponent_score]
            when ""
                key[:opponent_score] = "0"
        end
        }   
        
        details.each{|key| }
        Date.parse
        puts details

    #create data file 
        File.open("nba_schedule", "a+") do |f|
        f.write(details)
        end
    end
end
    


