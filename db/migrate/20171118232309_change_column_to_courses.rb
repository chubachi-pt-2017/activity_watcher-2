class ChangeColumnToCourses < ActiveRecord::Migration[5.0]
  def up
    change_column :courses, :title, :string, limit: 128, null: false
    change_column_default :courses, :title, ""
    add_index :courses, :title, unique: true
  end
  
  def down
    change_column :courses, :title, :string
    remove_index :courses, :title
  end
end
