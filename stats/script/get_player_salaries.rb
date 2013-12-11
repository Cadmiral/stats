#!/usr/bin/ruby2.0.0

require 'nokogiri'
require 'open-uri'
require 'pg'
require 'sequel'

DB=Sequel.connect(:adapter => 'postgres', :host => 'localhost', :database => 'stats_development')

class GetPlayerSalary
	def initialize

	    if File.exists?("player_daily_salaries")
	    File.delete("player_daily_salaries")
	    end

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


			salary = "#{xsalary} #{xname} \n"

			File.open("player_daily_salaries", "a++") do |f|
	        f.write(salary)
	      	end
			
			# Update the "todays_game" table in the Database
			# DB << "UPDATE todays_game SET salary = #{xsalary} WHERE todays_game.player_name = '#{xname}'"
			# DB << "UPDATE todays_game SET dollar_per_point = round((salary/avg_fd_points),2)"
		end
	end
    #remove unwanted array characters from file player_boxscore
    # get_salary=File.read("player_daily_salaries")
    # player_salaries=get_salary.gsub("][", ", ")
    # File.open("player_daily_salaries", "w") do |f|
    #     f.write(player_salaries)
    # end
end