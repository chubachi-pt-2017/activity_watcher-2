class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.string :title, limit: 128, null: false, default: ""
      t.datetime :start_date, null: false
      t.datetime :end_date, null: false
      t.string :description, limit: 256
      t.string :slack_domain, limit: 128, null: false, default: ""
      t.references :course, foreign_key: true

      t.timestamps
    end
    add_index :tasks, :title, unique: true
    add_index :tasks, :slack_domain, unique: true
  end
end
