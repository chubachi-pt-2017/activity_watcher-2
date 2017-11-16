class AddEmailConfirmationToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :email_confirmation, :boolean, default: false
  end
end
