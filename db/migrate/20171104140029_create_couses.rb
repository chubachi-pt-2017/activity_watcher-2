class CreateCouses < ActiveRecord::Migration[5.0]
  def change
    create_table :couses do |t|
      t.string :couse_name

      t.timestamps
    end
  end
end
