class CreateLeagueMembers < ActiveRecord::Migration[5.1]
  def change
    create_table :league_members do |t|
      t.integer :user_id
      t.integer :league_id
      t.timestamps
    end
  end
end
