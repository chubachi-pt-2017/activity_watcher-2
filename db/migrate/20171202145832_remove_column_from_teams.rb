class RemoveColumnFromTeams < ActiveRecord::Migration[5.0]
  def up
    remove_column :teams, :repository_name
    remove_column :teams, :service_url
    remove_column :teams, :ci_url
  end
  
  def down
    add_column :teams, :repository_name, :string, limit: 128, default: "", null: false
    add_column :teams, :service_url, :string, limit: 256
    add_column :teams, :ci_url, :string, limit: 256
  end
end
