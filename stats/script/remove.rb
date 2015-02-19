class RemoveCharacters

    def initialize
    	boxscore=File.read("player_boxscore")
		remove_bracket=boxscore.gsub("\"\"", "\"0\"").gsub("][", ", ").gsub(",\ ,\ ,", ",").gsub(",\ ,", ",")
		File.open("player_boxscore", "w") do |f|
    	f.write(remove_bracket)
		end
	end
end
