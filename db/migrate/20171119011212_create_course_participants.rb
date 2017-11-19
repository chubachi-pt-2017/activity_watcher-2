class CreateCourseParticipants < ActiveRecord::Migration[5.0]
  def change
    create_table :course_participants do |t|
      t.references :course, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :course_participants, [:course_id, :user_id], unique: true
  end
end
