class AddCouseIdToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :couse_id, :string
  end
end
