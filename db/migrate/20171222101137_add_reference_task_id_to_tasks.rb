class AddReferenceTaskIdToTasks < ActiveRecord::Migration[5.0]
  def change
    add_column :tasks, :reference_task_id, :integer
  end
end
