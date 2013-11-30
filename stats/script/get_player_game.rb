require 'nokogiri'
require 'open-uri'


#read names from player_avg 
getName=eval(File.read("player_avg"))
getName.each do |x|
    xname=x[:name]
    #delete rows with empty values
    if xname.chomp == ""
      getName.delete x
    else 

    #split first and last names & remove quotes and spaces
    player=xname.split(/\s+/,2) 
    strip_first=player[0]
    stripped=strip_first.tr("'","")
    first=stripped.tr(" ","")
    strip_last=player[1]
    stripped_last=strip_last.tr("'","")
    last=strip_last.tr(" ","")

    #get first letter of last name and also first 5 letters of lastname + first 2 letters of firstname
    last_first=last[0].downcase
    last_five=last[0..4].downcase
    first_two=first[0..1].downcase

    end

    doc = Nokogiri::HTML(open("http://www.basketball-reference.com/players/#{last_first}/#{last_five}#{first_two}01/gamelog/2014"))
    
    rows = doc.xpath('//table[@id="pgl_basic"]/tbody/tr') 

    details = rows.collect do |row|
      detail = {}
      [
        [:name, 'text()'],
        [:date, 'td[3]/a/text()'],
        [:opponent, 'td[7]/a/text()'],
        [:mins, 'td[10]/text()'],
        [:points, 'td[28]/text()'],
        [:rebounds, 'td[22]/text()'],
        [:assists, 'td[23]/text()'],
        [:steals, 'td[24]/text()'],
        [:blocks, 'td[25]/text()'],
        [:turnovers, 'td[26]/text()']

      ].each do |name, xpath|
      detail[name] = row.at_xpath(xpath).to_s.strip
      end
      detail
    end

    #add name from player_avg 
    details.each{|key| key[:name] = "#{xname}"}
    puts details

    File.open("player_game", "a+") do |f|
    f.write(details)
    end
end


