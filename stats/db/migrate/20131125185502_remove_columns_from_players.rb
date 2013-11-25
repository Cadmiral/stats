class RemoveColumnsFromPlayers < ActiveRecord::Migration
  def change
    remove_column :players, :add_assists_to_players, :string
    remove_column :players, :add_blocks_to_players, :string
  end
end
