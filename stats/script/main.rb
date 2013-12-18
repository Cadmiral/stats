
require_relative 'InjuryManager'
require_relative 'NBAPlayerManager'
require_relative 'AlgorithmManager'
require_relative 'BuildNbaBoxScore'
require_relative 'BuildNbaInjuryList'
require_relative 'SalaryHistoryScraper'

unless defined? DB
	# Setup DB Connector.
	DB=Sequel.connect(:adapter => 'postgres', :host => '174.129.141.105', :database => 'stats_development', :user=>'postgres', :password=>'pingpong21')
end

# Filename to keep track of when we last ran the
# script to get the boxscore.  (Script takes 5 min)
LASTUPDATE_FILENAME = "lastupdated.txt"


# Determine if you need to run the 5 minute update script.
# Return Boolean.
def needToRunUpdateScript
	for index in 0..ARGV.count-1
		if(ARGV[index] == '--boxscore' || ARGV[index] == '--all')
			# 'ruby main.rb --boxscore'
			# User force run!
			puts "-- Force Update 'boxscore' --"
			return true
		end
	end

	# Check if file even exists
	if(File.exist?(LASTUPDATE_FILENAME))
		if(File.zero?(LASTUPDATE_FILENAME))
			# WTF why is it empty.
			# Go get everything anyways.
			return true
		end
	else
		# First run, we need it allllll.
		puts "-- Tool First Run -- "
		return true
	end

	# Read the last time we ran the update box script.
	file = File.open(LASTUPDATE_FILENAME, 'r')
	file_date = file.gets
	puts "Box Score Last updated: " + file_date
	file.close


	# Convert to date in file to Time Object
	lastupdate_time = Time.parse(file_date)
	lastupdate_day_time = lastupdate_time.strftime("%m/%d/%Y")

	# Get Today's Day as a Time Object.
	today_day_time = Time.now.strftime("%d/%m/%Y")
	# Today when stats got updated.
	# ASSUMING STATS ARE UPDATED BY 3 AM everyday.
	# TODO: Check when stats update.
	today_statupdate_time = Time.parse(today_day_time) +  3*60

	# Yesterday at 3 a.m.
	yesterday_statupdate_time = Time.parse(today_day_time) +  3*60 - 24*60

	# Last Update is after Update time today.
	if(lastupdate_time > today_statupdate_time)
		# We already updated today.
		return false
	elsif(lastupdate_time < today_statupdate_time &&
		Time.now > today_statupdate_time)
		# We haven't gotten today's updates yet
		return true
	elsif (lastupdate_time < yesterday_statupdate_time)
		# We haven't updated in super long.
		return true
	else
		# I dunno what to do here...
		# this should never happen.
		return false
	end

	# We good nigga.  No need to run that shit.
	return false
end


# MAIN FUNCTION: where the magic happens.
#
# Description: To run type "ruby main.rb"
# => To force update of player boxscores type "ruby main.rb --boxscore".
# => Warning takes approx 5 min.
#
begin
	# SNF TODO: Keep for now.
	{
	# Check to see if we need to update the player game logs.
	#run_update_script_bool = needToRunUpdateScript
	# if(run_update_script_bool)
	# 	BuildNbaBoxScore.new

	# 	# Update the file that tells us when we late updated.
	# 	file = File.open(LASTUPDATE_FILENAME, 'w')
	# 	now_time = Time.now.strftime("%m/%d/%Y %H:%M")
	# 	file.write(now_time)
	# 	file.close
	# else
	# 	puts "'boxscore' is already up-to-date biatch!"
	# end
	}

	if(ARGV[0] == '--boxscore' || ARGV[0] == '--all')
		BuildNbaBoxScore.new
	end

	if(ARGV[0] == '--salary_history' || ARGV[0] == '--all')
		SalaryHistoryScraper.new
	end

	if(ARGV[0] == '--injuries' || ARGV[0] == '--injury' || ARGV[0] == '--all')
		BuildNbaInjuryList.new
	end

	#algoManager = AlgorithmManager.new
	#algoManager.runAlgorithm1
#	algoManager.runAlgorithm2
end

