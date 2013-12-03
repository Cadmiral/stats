
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
end