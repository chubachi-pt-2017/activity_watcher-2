class CreateUserUniversities < ActiveRecord::Migration[5.0]
  def change
    create_table :user_universities do |t|
      t.string :confirmation_token, limit: 256, null: false
      t.string :email, limit: 128, null: false
      t.string :student_no, limit: 64
      t.boolean :email_confirmed_flg, null: false, default: false
      t.references :user, foreign_key: true
      t.references :university, foreign_key: true

      t.timestamps
    end
    add_index :user_universities, :confirmation_token, unique: true
    add_index :user_universities, :email, unique: true
    add_index :user_universities, [:user_id, :university_id], unique: true
  end
end
