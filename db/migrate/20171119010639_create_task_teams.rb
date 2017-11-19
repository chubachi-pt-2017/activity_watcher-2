class CreateTaskTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :task_teams do |t|
      t.references :task, foreign_key: true
      t.references :team, foreign_key: true

      t.timestamps
    end
    add_index :task_teams, [:task_id, :team_id], unique: true
  end
end
