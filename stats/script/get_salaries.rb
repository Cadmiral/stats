#!/usr/bin/ruby2.0.0

require 'nokogiri'
require 'open-uri'
require_relative 'InjuredPlayer'


begin
	doc = Nokogiri::HTML(open('https://www.numberfire.com/nba/fantasy/fantasy-basketball-projections'))

	# Result Variable
	salary_dict = Hash.new


	# Scrape the data
	player_table = doc.css('script')
	salary_data = player_table[1].text

	# Rip out all the bullshit.
	salary_data.slice! "var NF_DATA = "
	salary_data.slice! "var KMQ_PUSH = []; "
	salary_data.slice! "var GAQ_PUSH = []; "
	salary_data.slice! '\t'
	salary_data.slice! '\n'
	salary_data.slice! '\r'
	salary_data[0] = ''
	salary_data[1] = ''

	# Change dictionary to Ruby Hash.
	salary_data = salary_data.gsub(':', "=>")

	# Run String as Code.
	# Populater 'salary_dict' variable
	eval_code = "salary_dict = "
	eval_code << salary_data
	eval(eval_code)

	puts "PLAYER COUNT: %d" % salary_dict['daily_projections'].length
	for index in 0...salary_dict['daily_projections'].length
#	for index in 0...20
		puts "------------------------------------------------"
		entry = salary_dict['daily_projections'][index]
		puts "player id: %d" % entry['nba_player_id'].to_i
		name = salary_dict['players'][entry['nba_player_id'].to_s]
		print "name: %s\n" % name['name']
		puts "salary: %d" % entry['fanduel_salary'].to_i
		puts "date: " + entry['date'].to_s
	end
	puts "------------------------------------------------"
	puts "PLAYER COUNT: %d" % salary_dict['daily_projections'].length


end
