json.array!(@boxscores) do |boxscore|
  json.extract! boxscore, 
  json.url boxscore_url(boxscore, format: :json)
end
