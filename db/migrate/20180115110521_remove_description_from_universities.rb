class RemoveDescriptionFromUniversities < ActiveRecord::Migration[5.0]
  def up
    remove_column :universities, :description
  end
  
  def down
    add_column :universities, :description, :text
  end
end
