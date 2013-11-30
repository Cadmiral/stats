
require_relative 'InjuryManager'
require_relative 'NBAPlayerManager'
require_relative 'AlgorithmManager'

begin
	#
	algoManager = AlgorithmManager.new
	algoManager.runAlgorithm

	# Check Injuries
	#injuryManager = InjuryManager.new
	#injuryManager.runTest


	# Check Array of Player Names for injuries
	# injuredPlayers = injuryManager.checkTeamForInjuries(arrayOfName)
	# if(injuredPlayers.length > 0)
	#     CHANGE SHIT
	# end
end