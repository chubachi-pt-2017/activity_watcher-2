class RenameColumnToCourses < ActiveRecord::Migration[5.0]
  def change
    rename_column :courses, :course_name, :title
  end
end
