class RemoveSlackDomainFromTasks < ActiveRecord::Migration[5.0]
  def up
    remove_column :tasks, :slack_domain
  end
  
  def down
    add_column :tasks, :slack_domain, :string, limit: 128, default: "", null: false
  end
end
