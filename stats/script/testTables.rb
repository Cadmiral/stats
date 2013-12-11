require_relative 'get_player_avg'
require_relative 'get_nba_schedule'
require_relative 'get_injury_report'
require_relative 'get_player_boxscore'
require_relative 'get_player_salaries'
# require_relative '../app/models/create_table'

begin
  GetPlayerAvg.new
  GetPlayerBoxscore.new
  GetNBASchedule.new
  GetInjuryReport.new
  GetPlayerSalary.new
end
