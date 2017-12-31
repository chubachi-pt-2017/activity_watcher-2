class CreateUserSlacks < ActiveRecord::Migration[5.0]
  def change
    create_table :user_slacks do |t|
      t.string :domain, limit: 128, default: "", null: false
      t.string :token, limit: 256, default: "", null: false
      t.string :url, limit: 512
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :user_slacks, :domain, unique: true
    add_index :user_slacks, :token, unique: true
  end
end
