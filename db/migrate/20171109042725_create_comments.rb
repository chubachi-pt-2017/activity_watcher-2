class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.references :task, foreign_key: true
      t.string :from
      t.text :body

      t.timestamps
    end
  end
end
