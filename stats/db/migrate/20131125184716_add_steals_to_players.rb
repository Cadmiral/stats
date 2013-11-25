class AddStealsToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :steals, :integer
    add_column :players, :add_blocks_to_players, :string
    add_column :players, :blocks, :integer
    add_column :players, :add_turnovers_to_columns, :string
    add_column :players, :turnovers, :integer
  end
end
