class RenameColumnsToCourses < ActiveRecord::Migration[5.0]
  def change
    rename_column :courses, :student_entry_start, :start_date
    rename_column :courses, :student_entry_end, :end_date
  end
end
