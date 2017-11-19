class CreateTeamParticipants < ActiveRecord::Migration[5.0]
  def change
    create_table :team_participants do |t|
      t.references :team, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :team_participants, [:team_id, :user_id], unique: true
  end
end
