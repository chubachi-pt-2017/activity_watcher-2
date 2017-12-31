class AddWorkspaceNameToUserSlacks < ActiveRecord::Migration[5.0]
  def change
    add_column :user_slacks, :workspace_name, :string, limit: 64, default: "", null: false
    add_index :user_slacks, :workspace_name, unique: true
  end
end
