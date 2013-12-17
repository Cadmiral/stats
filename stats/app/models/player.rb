class Player < ActiveRecord::Base
	has_many	:boxscores
	has_many	:todays_games
end
