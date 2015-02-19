require 'nokogiri'
require 'open-uri'

class GetInjuryReport
  def initialize

    if  File.exists?("injury_list")
        File.delete("injury_list")
    end

    doc = Nokogiri::HTML(open("http://www.basketball-reference.com/friv/injuries.cgi"))
    rows = doc.xpath('//table[@id="injuries"]/tbody/tr') 
    injury_list = rows.collect do |row|
      	detail = {}
          [
            [:team, 'td[1]/a/text()'],
            [:name, 'td[2]/a/text()'],
            [:date, 'td[3]/text()'],
            [:injury, 'td[4]/text()'],
            [:notes, 'td[5]/text()']
          ].each do |name, xpath|
          detail[name] = row.at_xpath(xpath).to_s.strip
          end
          detail
    end

    injury_list.each{|key| if key[:name]== ""
        key[:name] = "Norlens Otto McCollum"
    end
    }

    injury_list.each{|key| if key[:name]=="Nene"
        key[:name] = "Nene Hilario"
    end
    }
    
    injury_list.each{|key| case key[:team]
        when "Atlanta Hawks"
            key[:team] = "ATL"
        when "Boston Celtics"
            key[:team] = "BOS"
        when "Brooklyn Nets"
            key[:team] = "BKN"
        when "Charlotte Bobcats"
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
    puts injury_list

    File.open("injury_list", "w") do |f|
    f.write(injury_list)
    end

    injured=File.read("injury_list")
        injuries=injured.gsub("'", "")
        File.open("injury_list", "w") do |f|
            f.write(injuries)
        end
    end
end
