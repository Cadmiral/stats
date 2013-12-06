boxscore=File.read("player_boxscore")
create_boxscore=boxscore.gsub("][", ", ")
File.open("player_boxscore", "w") do |f|
    f.write(create_boxscore)
end