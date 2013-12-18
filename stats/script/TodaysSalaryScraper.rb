#!/usr/bin/ruby2.0.0

require 'pg'
require 'sequel'
require 'nokogiri'
require 'open-uri'
require_relative 'Utilities'

DB=Sequel.connect(:adapter => 'postgres', :host => '174.129.141.105', :database => 'stats_development', :user=>'postgres', :password=>'pingpong21')

class TodaysSalaryScraper
	def initialize
		@forceCreateFlag = false

		# Result Variable
		@salary_dict = Hash.new

		# Do-While loop is here because sometimes the return gets fucked up.
		begin
			puts "Attempting to Grab Salary HTML..."
			# Scrape the Site, but no parsing done yet.
			doc = Nokogiri::HTML(open('https://www.numberfire.com/nba/fantasy/fantasy-basketball-projections'))

			# Scrape the data
			player_table = doc.css('script')
			salary_data = player_table[1].text

			if(salary_data.include? "var heap=heap")
				# Wait 3 seconds and try again.
				sleep(3)
			end
		end while (salary_data.include? "var heap=heap")

		# Strip out all the bullshit.
		salary_data.slice! "var NF_DATA = "
		salary_data.slice! "var KMQ_PUSH = []; "
		salary_data.slice! "var GAQ_PUSH = []; "
		salary_data.slice! '\t'
		salary_data.slice! '\n'
		salary_data.slice! '\r'
		salary_data[0] = ''
		salary_data[1] = ''

		# Change dictionary to Ruby Dictionary (Hash) format.
		salary_data = salary_data.gsub(':', "=>")

		# Run String as Code.
		# Initialize '@salary_dict' variable
		eval_code = "@salary_dict = "
		eval_code << salary_data
		eval(eval_code)
	end

	# SCRAPE ALL THE SALARIES.
	def scrapeAndPopulate
		readyFlag = readyToScrape
		# Check if we should parse the scraped salaries yet.
		if(readyFlag || @forceCreateFlag)

			if(@forceCreateFlag)
				puts "FORCE Create todays_game table."
			end

			puts "Scraping Salaries..."

			# Move the entires in todays_game to boxscore, and create a new todays_game table
			moveTodaysGameToBoxscore

			# Use to get the Team Abbreviation.
			utilities = Utilities.new

			# Debug Print.
			#puts "PLAYER COUNT: %d" % @salary_dict['daily_projections'].length
			for index in 0...@salary_dict['daily_projections'].length
				entry_dict = @salary_dict['daily_projections'][index]
				players_dict = @salary_dict['players'][entry_dict['nba_player_id'].to_s]
				teams_dict = @salary_dict['teams'][entry_dict['opponent_id'].to_s]

				# Player Name
				# Strip unwanted things out of name to match db.
				xname = players_dict['name']
				xname.to_s.gsub!("'", '')
				xname.to_s.gsub!("-", '')
				xname.to_s.gsub!(".", '')
				xname.to_s.gsub!(" Jr", '')
				xname.to_s.gsub!(" III", '')
				# Opponent
				xopponent = utilities.getTeamAbbr(teams_dict['name'])
				# Player Salary
				xsalary = entry_dict['fanduel_salary'].to_i
				# Date
				xdate = entry_dict['date']

				# Debug Print.
				# puts xdate.to_s + " : " + xname.to_s + " : " + xsalary.to_s + " : " + xopponent.to_s

				# Create Entry in todays_game table.
				DB << "INSERT INTO todays_game (date,
												player_name,
												opponent,
												salary)
										VALUES ('#{xdate}',
												'#{xname}',
												'#{xopponent}',
												'#{xsalary}')"
			end # end for loop players
		end # end if

		# Reset force flag.
		@forceCreateFlag = false

	end # end initialize

	def moveTodaysGameToBoxscore
		# DANGER: This could insert duplicates and incomplete entries.

		# Move Entries from todays_game to boxscore
		DB << "INSERT INTO boxscore SELECT * FROM todays_game"

		# Create New todays_game table.
		# This is done to try and prevent duplicate entries in box_score.
        DB << "DROP TABLE IF EXISTS todays_game" << "CREATE TABLE todays_game (date DATE,
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
	end

	# For Development.
	def forceCreateTodaysGameTable
		# Create New todays_game table.
		# This is done to try and prevent duplicate entries in box_score.
        DB << "DROP TABLE IF EXISTS todays_game" << "CREATE TABLE todays_game (date DATE,
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
		@forceCreateFlag = true
		scrapeAndPopulate
	end

	private
		@salary_dict
		@forceCreateFlag

		def readyToScrape
			# Scrape a little bit to see if salaries have been populated yet.
			salaryValue = @salary_dict['daily_projections'][0]['fanduel_salary'].to_i
			if(salaryValue == 0)
				puts "Today's Salaries are NOT ready"
				return false
			else
				puts "Today's Salaries are ready"
				return true
			end
		end
end

begin
	obj = TodaysSalaryScraper.new
	obj.scrapeAndPopulate
end



