class CreateTodaysGames < ActiveRecord::Migration
  def change
    create_table :todays_games do |t|

      t.timestamps
    end
  end
end
