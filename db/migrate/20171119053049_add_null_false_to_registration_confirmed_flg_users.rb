class AddNullFalseToRegistrationConfirmedFlgUsers < ActiveRecord::Migration[5.0]
  def up
    change_column :users, :registration_confirmed_flg, :boolean, default: false, null: false
  end

  def down
    change_column :users, :registration_confirmed_flg, :boolean, default: false
  end
end
