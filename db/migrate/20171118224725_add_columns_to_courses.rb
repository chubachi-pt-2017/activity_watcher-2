class AddColumnsToCourses < ActiveRecord::Migration[5.0]
  def change
    add_column :courses, :student_entry_start, :datetime, null: false
    add_column :courses, :student_entry_end, :datetime, null: false
    add_column :courses, :description, :string, limit: 256
    add_reference :courses, :owner, foreign_key: { to_table: :users }
    add_reference :courses, :university, foreign_key: true
  end
end
