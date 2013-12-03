
require_relative 'InjuryManager'
require_relative 'NBAPlayerManager'
require_relative 'AlgorithmManager'
require_relative 'BuildNbaBoxScore'

begin
	# TODO: Uncomment every day at least one.
	#BuildNbaBoxScore.new

	algoManager = AlgorithmManager.new

	algoManager.runAlgorithm1
#	algoManager.runAlgorithm2

	# Check Injuries
	#injuryManager = InjuryManager.new
	#injuryManager.runTest


	# Check Array of Player Names for injuries
	# injuredPlayers = injuryManager.checkTeamForInjuries(arrayOfName)
	# if(injuredPlayers.length > 0)
	#     CHANGE SHIT
	# end
end