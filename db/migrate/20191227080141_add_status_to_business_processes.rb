class AddStatusToBusinessProcesses < ActiveRecord::Migration[5.2]
  def change
    add_column :business_processes, :status, :string
  end
end
