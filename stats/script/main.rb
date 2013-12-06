
require_relative 'InjuryManager'
require_relative 'NBAPlayerManager'
require_relative 'AlgorithmManager'
require_relative 'BuildNbaBoxScore'


# Filename to keep track of when we last ran the
# script to get the boxscore.  (Script takes 5 min)
LASTUPDATE_FILENAME = "lastupdated.txt"

# Determine if you need to run the 5 minute update script.
# Return Boolean.
def needToRunUpdateScript

	if(ARGV[0] == '--update')
		# 'ruby main.rb --update'
		# User said run it bitch!
		puts "-- Force Update --"
		return true
	else
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
		lastupdate_day_time = lastupdate_time.strftime("%d/%m/%Y")

		# Get Today's Day as a Time Object.
		today_day_time = Time.now.strftime("%d/%m/%Y")

		# Today when stats got updated.
		# ASSUMING STATS ARE UPDATED BY 3 AM everyday.
		# TODO: Check when stats update.
		today_statupdate_time = Time.parse(today_day_time) +  3*60

		# Yesterday when stats gots updated.
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
	end

	# We good nigga.  No need to run that shit.
	return false
end

# MAIN FUNCTION: where the magic happens.
#
# Description: To run type "ruby main.rb"
# => To force update of player boxscores type "ruby main.rb --update".
# => Warning takes approx 5 min.
#
#
begin
	# Check to see if we need to update the player game logs.
	run_update_script_bool = needToRunUpdateScript

	if(run_update_script_bool)
		puts "Updating Player Boxscores in DB..."
		BuildNbaBoxScore.new

		# Update the file that tells us when we late updated.
		file = File.open(LASTUPDATE_FILENAME, 'w')
		now_time = Time.now.strftime("%d/%m/%Y %H:%M")
		file.write(now_time)
		file.close
	else
		puts "Database is already up-to-date biatch!"
	end


	algoManager = AlgorithmManager.new
	algoManager.runAlgorithm1
#	algoManager.runAlgorithm2
end