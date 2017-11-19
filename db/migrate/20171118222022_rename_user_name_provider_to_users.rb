class RenameUserNameProviderToUsers < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :user_name, :login_name
    rename_column :users, :provider, :login_provider
    add_index :users, :login_name, unique: true
    add_index :users, [:login_provider, :uid], unique: true
  end
end
