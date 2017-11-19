class AddTimeStampsToTeams < ActiveRecord::Migration[5.0]
  def change
    add_timestamps :teams, null: false
  end
end
