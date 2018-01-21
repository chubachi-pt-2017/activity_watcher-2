class AddPublicFlgToCourses < ActiveRecord::Migration[5.0]
  def change
    add_column :courses, :publish_other_universities_flg, :boolean, default: false
  end
end
