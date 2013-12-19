#!/usr/bin/ruby2.0.0
require 'pg'
require 'sequel'
require 'nokogiri'
require 'open-uri'

# DB=Sequel.connect(:adapter => 'postgres', :host => 'localhost', :database => 'stats_development', :user=>'postgres', :password=>'pingpong21')

class SalaryHistoryScraper
	def initialize
		puts "Adding salary history to boxscores..."

		startDate = "29-10-2013"
		formated_date = Date.parse(startDate)

		while(1)
			if(formated_date > Date.today)
				break
			end
			salary_date = formated_date.strftime("%Y-%m-%d")
			filepath = "./SalaryHistory/Salaries" + salary_date[5..6] + "." + salary_date[8..9] + ".html"

			count = 0
			if(File.exist?(filepath))
				doc = Nokogiri::HTML(open(filepath))
				salary_html = doc.css('table.gridT').css('tr')

				for index in 1...salary_html.count

					#salary_date = Date.parse(salary_date)

					# Get the Player Name.
					player_name = salary_html[index].css('td')[6].text
					if(player_name == "Name")
						# Skip non legit players
						next
					end

					player_name.gsub!("'", '')
					player_name.gsub!("-", '')
					player_name.gsub!(".", '')
					player_name.gsub!(" Jr", '')
					player_name.gsub!(" III", '')
					player_name.sub!(' ', '')
					last_name, first_name= player_name.split(',', 2)
					player_name = first_name + ' ' + last_name

					# Stupid custom name bullshit...
					if(player_name == "Wes Johnson")
						player_name = "Wesley Johnson"
					end

					# Get the Player Salary.
					player_salary = salary_html[index].css('td')[3].text
					player_salary.sub!('$', '')
					player_salary.sub!(',', '')

					# Update boxscores database table
					DB << "UPDATE boxscores SET salary = #{player_salary.to_i}
											WHERE player_name = '#{player_name}'
											AND date = '#{salary_date}';"
				end
			end

			# Increment Date
			formated_date = formated_date+1
		end # End while

		# Update boxscores database table
		DB << "UPDATE boxscores SET salary = 0
								WHERE salary IS NULL;"
		puts "DONE"
	end
end