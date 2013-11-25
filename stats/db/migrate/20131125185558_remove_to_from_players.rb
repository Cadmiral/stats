class RemoveToFromPlayers < ActiveRecord::Migration
  def change
    remove_column :players, :add_turnovers_to_columns, :string
    remove_column :players, :updated_at, :timestamps
  end
end
