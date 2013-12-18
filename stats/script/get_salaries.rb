#!/usr/bin/ruby2.0.0

require 'nokogiri'
require 'open-uri'
require 'pg'
require 'sequel'

DB=Sequel.connect(:adapter => 'postgres', :host => 'localhost', :database => 'stats_development', :user=>'postgres', :password=>'pingpong21')

begin
	doc = Nokogiri::HTML(open('https://www.numberfire.com/nba/fantasy/fantasy-basketball-projections'))

	# Result Variable
	salary_dict = Hash.new


	# Scrape the data
	player_table = doc.css('script')
	salary_data = player_table[1].text

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
	# Populater 'salary_dict' variable
	eval_code = "salary_dict = "
	eval_code << salary_data
	eval(eval_code)

	puts "PLAYER COUNT: %d" % salary_dict['daily_projections'].length
	for index in 0...salary_dict['daily_projections'].length
		entry_dict = salary_dict['daily_projections'][index]
		name_dict = salary_dict['players'][entry_dict['nba_player_id'].to_s]

		# Player Name
		# Strip unwanted things out of name to match db.
		xname = name_dict['name']
		xname.to_s.gsub!("'", '')
		xname.to_s.gsub!("-", '')
		xname.to_s.gsub!(".", '')
		xname.to_s.gsub!(" Jr", '')
		xname.to_s.gsub!(" III", '')

		# Player Salary
		xsalary = entry_dict['fanduel_salary'].to_i
		# Date
		xdate = entry_dict['date']

		# Update the "todays_game" table in the Database
		DB << "UPDATE todays_games SET salary = #{xsalary} WHERE todays_games.player_name = '#{xname}';"
	end


end
