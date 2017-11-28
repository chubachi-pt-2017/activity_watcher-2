class AddDueDateToUserUniversities < ActiveRecord::Migration[5.0]
  def change
    add_column :user_universities, :email_confirmation_due_date, :datetime, null: false
  end
end
