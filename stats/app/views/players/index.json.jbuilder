json.array!(@players) do |player|
  json.extract! player, :first, :last
  json.url player_url(player, format: :json)
end
