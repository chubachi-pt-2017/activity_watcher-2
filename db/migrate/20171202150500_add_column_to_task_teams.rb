class AddColumnToTaskTeams < ActiveRecord::Migration[5.0]
  def change
    add_column :task_teams, :repository_name, :string, limit: 128, default: "", null: false
    add_column :task_teams, :service_url, :string, limit: 256
    add_column :task_teams, :ci_url, :string, limit: 256
  end
end
