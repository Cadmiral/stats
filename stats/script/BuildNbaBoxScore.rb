require 'pg'
require 'sequel'
require 'nokogiri'
require 'open-uri'

#DB=Sequel.connect(:adapter => 'postgres', :host => 'localhost', :database => 'stats_development', :user=>'postgres', :password=>'pingpong21')

class BuildNbaBoxScore

    def initialize
        puts "Creating table 'boxscores'..."

        #create data file
        DB << "DROP TABLE IF EXISTS boxscores" << "CREATE TABLE boxscores (date DATE,
                                                                        team_name VARCHAR (32),
                                                                        player_name VARCHAR(32),
                                                                        player_id INT,
                                                                        home VARCHAR(32),
                                                                        opponent VARCHAR(32),
                                                                        mins VARCHAR(32),
                                                                        points INT,
                                                                        fg_attempts INT,
                                                                        fg_percent DECIMAL,
                                                                        rebounds INT,
                                                                        assists INT,
                                                                        steals INT,
                                                                        blocks INT,
                                                                        turnovers INT,
                                                                        fouls INT,
                                                                        salary INT,
                                                                        fd_points DECIMAL)"
        #read from file
        table=File.read("player_url_name")

        #modify file to read strings correctly
        player_url_name=table.split(/\n/)

        count = 0
        #create variables from file
        player_url_name.each do |a|
            url_name = a
            first_letter = a[0]

            if match = a.match(/\s*(\w+)\s+(\w+)\s+(\w+)\s*/)
                url_name, first, last = match.captures
            end

            #get data from bball-refernce
            doc = Nokogiri::HTML(open("http://www.basketball-reference.com/players/#{first_letter}/#{url_name}/gamelog/2014"))
            rows = doc.xpath('//table[@id="pgl_basic"]/tbody/tr')

            details = rows.collect do |row|
                detail = {}
                    [
                        [:name, 'text()'],
                        [:team, 'td[5]/a/text()'],
                        [:date, 'td[3]/a/text()'],
                        [:home, 'td[6]/text()'],
                        [:opponent, 'td[7]/a/text()'],
                        [:mins, 'td[10]/text()'],
                        [:points, 'td[28]/text()'],
                        [:rebounds, 'td[22]/text()'],
                        [:assists, 'td[23]/text()'],
                        [:steals, 'td[24]/text()'],
                        [:blocks, 'td[25]/text()'],
                        [:turnovers, 'td[26]/text()']
                    ].each do
                        |name, xpath|
                        detail[name] = row.at_xpath(xpath).to_s.strip
                    end
            detail
            end

            #add value into key :name
            details.each{|key| key[:name] = "#{first} #{last}"}

            #change the home/away variables to human readable
            details.each{
                |key|

                if key[:home]=="@"
                  key[:home] = "AWAY"
                else
                  key[:home] = "HOME"
                end
            }

            # DEBUG PRINT
            count += 1
            print "Count: %d\r" % count.to_s

            details.each do |x|
                xname=x[:name]
                xdate=x[:date]
                xteam=x[:team]
                xhome=x[:home]
                xopponent=x[:opponent]
                xmins=x[:mins]
                xpoints=x[:points].to_i
                xfg_attempts=x[:fg_attempts].to_i
                xfg_percent=x[:fg_percent].to_f
                xrebounds=x[:rebounds].to_i
                xassists=x[:assists].to_i
                xsteals=x[:steals].to_i
                xblocks=x[:blocks].to_i
                xturnovers=x[:turnovers].to_i
                xfouls=x[:fouls].to_i


                if(xteam == "")
                    next
                end

                # Insert Entry
                DB << "INSERT INTO boxscores (date,
                                            team_name,
                                            player_name,
                                            home,
                                            opponent,
                                            mins,
                                            points,
                                            fg_attempts,
                                            fg_percent,
                                            rebounds,
                                            assists,
                                            steals,
                                            blocks,
                                            turnovers,
                                            fouls)
                                    VALUES ('#{xdate}',
                                            '#{xteam}',
                                            '#{xname}',
                                            '#{xhome}',
                                            '#{xopponent}',
                                            '#{xmins}',
                                            '#{xpoints}',
                                            '#{xfg_attempts}',
                                            '#{xfg_percent}',
                                            '#{xrebounds}',
                                            '#{xassists}',
                                            '#{xsteals}',
                                            '#{xblocks}',
                                            '#{xturnovers}',
                                            '#{xfouls}')"
            end
        end # for loop for each player
        puts ""
    end # end intialize
end # end class


