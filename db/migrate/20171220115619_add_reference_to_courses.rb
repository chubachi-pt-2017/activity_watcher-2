class AddReferenceToCourses < ActiveRecord::Migration[5.0]
  def change
    add_reference :courses, :user_slack
  end
end
