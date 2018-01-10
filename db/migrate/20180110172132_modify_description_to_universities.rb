class ModifyDescriptionToUniversities < ActiveRecord::Migration[5.0]
  def up
    change_column :universities, :description, :text
  end
  
  def down
    change_column :universities, :description, :string, limit: 256
  end
end
