class RebaseIndexTitleToTasks < ActiveRecord::Migration[5.0]
  def up
    remove_index :tasks, :title
    add_index :tasks, [:title, :course_id], unique: true
  end
  
  def down
    remove_index :tasks, [:title, :course_id]
    add_index :tasks, :title, unique: true
  end
end
