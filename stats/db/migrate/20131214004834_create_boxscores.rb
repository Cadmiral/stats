class CreateBoxscores < ActiveRecord::Migration
  def change
    create_table :boxscores do |t|

      t.timestamps
    end
  end
end
