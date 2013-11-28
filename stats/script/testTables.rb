#!/usr/bin/ruby1.8

require 'nokogiri'
require 'open-uri'
require 'json'

doc = Nokogiri::HTML(open('http://www.basketball-reference.com/leagues/NBA_2014_per_game.html'))
rows = doc.xpath('//table[@id="per_game"]/tbody/tr')
details = rows.collect do |row|
  detail = {}
  [
    ['td[2]/a/text()'],
    ['td[20]/text()'],
    ['td[23]/text()'],
    ['td[24]/text()'],
    ['td[25]/text()'],
    ['td[26]/text()'],
    ['td[27]/text()'],

    # [:name, 'td[2]/a/text()'],
    # [:points, 'td[20]/text()'],
    # [:rebounds, 'td[23]/text()'],
    # [:assists, 'td[24]/text()'],
    # [:steals, 'td[25]/text()'],
    # [:blocks, 'td[26]/text()'],
    # [:turnovers, 'td[27]/text()'],
  ].each do |xpath|
    detail[xpath] = row.at_xpath(xpath)
  #   Player.create(:points => xpath.text)
   end
  detail

  # ].each do |name, xpath|
  #   detail[name] = row.at_xpath(xpath).to_s.strip
  # end
  # detail
end
puts details
# File.open("tables", "w") do |f|
#   f.write(details)
# end
def name

  tables=eval(File.read("/Users/canguyen/stats/script/tables"))
  tables[0][:name]

end
