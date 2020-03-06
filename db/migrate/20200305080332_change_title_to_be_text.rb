class ChangeTitleToBeText < ActiveRecord::Migration[5.2]
  def up
    change_column :notifications, :title, :text
  end
  
  def down
    change_column :notifications, :title, :string 
  end
end
