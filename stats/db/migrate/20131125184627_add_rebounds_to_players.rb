class AddReboundsToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :rebounds, :integer
    add_column :players, :add_assists_to_players, :string
    add_column :players, :assists, :integer
  end
end
