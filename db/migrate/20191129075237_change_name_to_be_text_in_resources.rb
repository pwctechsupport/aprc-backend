class ChangeNameToBeTextInResources < ActiveRecord::Migration[5.2]
  def up
    change_column :resources, :name, :text
  end
  
  def down
    change_column :resources, :name, :string
  end
end
