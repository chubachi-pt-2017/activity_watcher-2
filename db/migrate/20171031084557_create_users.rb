class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :user_name, limit: 64, null: false, default: ""
      t.string :provider, null: false, default: ""
      t.string :uid, null: false, default: ""
      t.string :oauth_token, null: false, default: ""
      t.string :email, limit: 128, null: false, default: ""
      t.string :user_full_name, limit: 64, null: false, default: ""
      t.integer :university_id, limit: 2, null: false, default: 1
      t.string :slack_user, limit: 64, null: false, default: ""
      t.string :student_no, limit: 64, null: false, default: ""

      t.timestamps
    end
    
    add_index :users, :user_name, unique: true
    add_index :users, [:provider, :uid], unique: true
    add_index :users, :email, unique: true
    add_index :users, [:university_id, :student_no], unique: true
    add_index :users, :slack_user, unique: true
  end
end
