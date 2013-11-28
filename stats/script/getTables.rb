#!/usr/bin/ruby1.8


require 'nokogiri'
require 'open-uri'
require 'json'

doc = Nokogiri::HTML(open('http://www.basketball-reference.com/leagues/NBA_2014_per_game.html'))
rows = doc.xpath('//table[@id="per_game"]/tbody/tr')
details = rows.collect do |row|
  detail = {}
  [
    [:name, 'td[2]/a/text()'],
    [:points, 'td[29]/text()'],
    [:rebounds, 'td[23]/text()'],
    [:assists, 'td[24]/text()'],
    [:steals, 'td[25]/text()'],
    [:blocks, 'td[26]/text()'],
    [:turnovers, 'td[27]/text()'],

  ].each do |name, xpath|
    detail[name] = row.at_xpath(xpath).to_s.strip

      rows.search('td:empty').each{|n| n.content = 'default value'}

  end

  detail
end


File.open("tables", "w") do |f|
  f.write(details)
end

# tables=eval(File.read("/Users/canguyen/stats/script/tables"))

# tables.each do |key, value|
#   value.each do |k,v|
#     puts k
#     puts v
#   end
# end
