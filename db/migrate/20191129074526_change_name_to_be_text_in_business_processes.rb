class ChangeNameToBeTextInBusinessProcesses < ActiveRecord::Migration[5.2]
  def up
    change_column :business_processes, :name, :text
  end
  
  def down
    change_column :business_processes, :name, :string
  end
end
