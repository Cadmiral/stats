#!/usr/bin/ruby2.0.0

require 'pg'
require 'sequel'
require 'nokogiri'
require 'open-uri'
require_relative 'Utilities'

unless defined? DB
	# Setup DB Connector.
	puts " TodaysSalaryScraper.rb: Define DB Connector"
	DB=Sequel.connect(:adapter => 'postgres', :host => '174.129.141.105', :database => 'stats_development', :user=>'postgres', :password=>'pingpong21')
end

unless defined? LASTUPDATE_FILENAME
	# Filename to keep track of when we last ran the
	# script to get the boxscore.  (Script takes 5 min)
	LASTUPDATE_FILENAME = "lastupdated.txt"
end

class TodaysSalaryScraper
	def initialize
		# Do nothing for now.
	end # end initialize

	# SCRAPE ALL THE SALARIES.
	def scrapeAndPopulate
		puts "\nBEGIN: Getting Today's FanDuel Salaries..."

		# Read file to see when we last updated.
		readLastUpdatedFileLog

		# Log Update?
		logFlag = false

		# Get the HTML to scrape.
		getSalaryHTML

		# Check if Salaries are ready.
		readyFlag = readyToScrape

		# Check if we should parse the scraped salaries yet.
		if(readyFlag || @forceCreateFlag)

			if(@forceCreateFlag)
				puts "FORCE Create todays_game_stats table."
			end

			# Move the entires in todays_game_stats to boxscore, and create a new todays_game_stats table
			moveTodaysGameToBoxscore

			# Use to get the Team Abbreviation.
			utilities = Utilities.new

			xdate = nil

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

				# SNF TODO: Implement this.
				# if(@salaries_updated_date >= xdate)
				# 	logFlag = false
				# 	break
				# end


				# Debug Print.
				# puts xdate.to_s + " : " + xname.to_s + " : " + xsalary.to_s + " : " + xopponent.to_s

				# Create Entry in todays_game_stats table.
				DB << "INSERT INTO todays_game_stats (date,
													player_name,
													opponent,
													salary)
											VALUES ('#{xdate}',
													'#{xname}',
													'#{xopponent}',
													'#{xsalary}')"
				logFlag = true
			end # end for loop players

			if(logFlag)
				# Log what we just updated.
				writeLastUpdatedFileLog(xdate)
			end
		end # end if

		# Reset force flag.
		@forceCreateFlag = false

		puts "DONE: Getting Today's Games Boxscore Statistics..."
	end # end scrapeAndPopulate

	def moveTodaysGameToBoxscore
		# DANGER: This could insert duplicates and incomplete entries.

		# Move Entries from todays_game_stats to boxscore
		DB << "INSERT INTO boxscore SELECT * FROM todays_game_stats"

		# Create Yesterday's Game table.
		# This is for development and testing.
        DB << "DROP TABLE IF EXISTS yesterdays_game_stats" << "CREATE TABLE yesterdays_game_stats (date DATE,
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
		DB << "INSERT INTO yesterdays_game_stats SELECT * FROM todays_game_stats"

		# Create New todays_game_stats table.
		# This is done to try and prevent duplicate entries in box_score.
        DB << "DROP TABLE IF EXISTS todays_game_stats" << "CREATE TABLE todays_game_stats (date DATE,
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
	end # end moveTodaysGameToBoxscore

	# For Development.
	def forceCreateTodaysGameTable
		# Create New todays_game_stats table.
		# This is done to try and prevent duplicate entries in box_score.
        DB << "DROP TABLE IF EXISTS todays_game_stats" << "CREATE TABLE todays_game_stats (date DATE,
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
	end # end forceCreateTodaysGameTable

	private
		# Last Time Todays Salary was Scraped.
		@salaries_updated_date
		# List of Todays Player Salaries
		@salary_dict
		# Flag to force scrape of salaries page.
		@forceCreateFlag

		def readyToScrape
			# Scrape a little bit to see if salaries have been populated yet.
			salaryValue = @salary_dict['daily_projections'][0]['fanduel_salary'].to_i
			if(salaryValue == 0)
				puts "Sorry. Today's Salaries are NOT ready..."
				return false
			else
				puts "Today's Salaries are ready to be scraped."
				return true
			end
		end # end readyToScrape

		def getSalaryHTML
			@forceCreateFlag = false

			# Result Variable
			@salary_dict = Hash.new

			# Do-While loop is here because sometimes the return gets fucked up.
			begin
				puts "INIT: Attempting to Grab Salary HTML..."
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
		end # getSalaryHTML

		def writeLastUpdatedFileLog(date)
			# Read the Dictionary in the file.
			file = File.open(LASTUPDATE_FILENAME, 'r')
			file_data = file.gets
			# Note: eval() is a huge security risk.  Do not use if user input can ever effect string input.
			file_dict = eval(file_data)

			# Only Update the field(s) that is/are applicable.
			file = File.open(LASTUPDATE_FILENAME, 'w')
			file_dict["salaries_updated_date"] = date.to_s
			file.write(file_dict)

			file.close
		end # logTodaysSalariesUpdate

		def readLastUpdatedFileLog
			# Read the last time we ran the salary scrape.
			file = File.open(LASTUPDATE_FILENAME, 'r')
			file_data = file.gets
			# Note: eval() is a huge security risk.  Do not use if user input can ever effect string input.
			file_hash = eval(file_data)

			if(file_hash.has_key?("salaries_updated_date"))
				# Set the date from the file.
				@salaries_updated_date = file_hash['salaries_updated_date']
			else
				# Set to zero because we have never scraped.
				@salaries_updated_date = Date.new(2001,1,1)
			end
			file.close
		end
end



