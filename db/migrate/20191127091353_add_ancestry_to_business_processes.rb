class AddAncestryToBusinessProcesses < ActiveRecord::Migration[5.2]
  def change
    add_column :business_processes, :ancestry, :string
    add_index :business_processes, :ancestry
  end
end
