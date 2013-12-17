json.array!(@todays_games) do |todays_game|
  json.extract! todays_game, 
  json.url todays_game_url(todays_game, format: :json)
end
