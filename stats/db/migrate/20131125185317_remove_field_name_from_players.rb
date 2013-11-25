class RemoveFieldNameFromPlayers < ActiveRecord::Migration
  def change
    remove_column :players, :created_at, :datetime
  end
end
