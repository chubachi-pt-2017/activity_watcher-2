class RemoveSlackUserFromUsers < ActiveRecord::Migration[5.0]
  def up
    remove_column :users, :slack_user
  end
  
  def down
    add_column :users, :slack_user, :string, limit: 64, default: "", null: false
  end
end
