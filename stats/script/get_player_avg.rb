require 'nokogiri'
require 'open-uri'
require_relative '../app/models/create_table'


class GetPlayerAvg

    def initialize

      #fetch data from site and print out to file player_avg
      doc = Nokogiri::HTML(open('http://www.basketball-reference.com/leagues/NBA_2014_per_game.html')) 
      rows = doc.xpath('//table[@id="per_game"]/tbody/tr') 
      details = rows.collect do |row|
        detail = {}
        [
          [:name, 'td[2]/a/text()'],
          [:pos, 'td[3]/text()'],
          [:team, 'td[5]/a/text()'],
          [:mins, 'td[8]/text()'],
          [:points, 'td[29]/text()'],
          [:rebounds, 'td[23]/text()'],
          [:assists, 'td[24]/text()'],
          [:steals, 'td[25]/text()'],
          [:blocks, 'td[26]/text()'],
          [:turnovers, 'td[27]/text()'],

        ].each do |name, xpath|
          detail[name] = row.at_xpath(xpath).to_s.strip
        end
        detail
      end

      #remove duplicate row names
      details.uniq! {|i| i[:name]}  

      #remove unwanted empty rows
      details.each do |x|
        xname=x[:name]
          if xname.chomp == ""
            details.delete x
          end
        end

      #write file after removing unwanted rows
      File.open("player_avg", "w") do |f|
        f.write(details)
      end
    end
end
