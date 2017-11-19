class RebaseTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :teams do |t|
      t.string :name, limit: 64, null: false, default: ""
      t.string :description, limit: 256
      t.string :repository_name, limit: 128, null: false, default: ""
      t.string :service_url, limit: 256
      t.string :ci_url, limit: 256
    end
    add_index :teams, :name, unique: true
    add_index :teams, :repository_name, unique: true
  end
end
