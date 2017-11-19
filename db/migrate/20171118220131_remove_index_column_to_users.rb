class RemoveIndexColumnToUsers < ActiveRecord::Migration[5.0]
  def change
    remove_index :users, :email
    remove_index :users, [:provider, :uid]
    remove_index :users, [:university_id, :student_no]
    remove_index :users, :user_name
    remove_column :users, :email
    remove_column :users, :university_id
    remove_column :users, :student_no
  end
end
