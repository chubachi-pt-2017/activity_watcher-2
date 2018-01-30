class AddCommentToTaskTeams < ActiveRecord::Migration[5.0]
  def change
    add_column :task_teams, :comment, :text
  end
end
