class Table < ActiveRecord::Base
	  attr_accessible :name, :event_description, :start_at, :end_at, :status, :eventable_id

end

def write_json
  events_json = []
  Table.all.each do |event|
    event_json = {
      "id" => event.id,
      "start" => event.start_at,
      "end" => event.end_at,
      "title" => event.name,
      "body" => event.event_description,
      "status" => event.status
    } 
    events_json << event_json
  end
  File.open("tables","w") do |f|
    f.write(tables.to_json)
end
end

puts event.json


# player=Player.new(File.read("/Users/canguyen/stats/script/tables")).result

# puts player

# tables=YAML.load(ERB.new(File.read("/Users/canguyen/stats/script/tables")).result)