class ChangeLengthRepositoryNameToTaskTeams < ActiveRecord::Migration[5.0]
  def up
    change_column :task_teams, :repository_name, :string, limit: 256, default: "", null: false
  end

  def down
    change_column :task_teams, :repository_name, :string, limit: 128, default: "", null: false
  end
end
