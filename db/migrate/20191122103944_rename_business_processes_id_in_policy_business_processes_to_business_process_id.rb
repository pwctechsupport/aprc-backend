class RenameBusinessProcessesIdInPolicyBusinessProcessesToBusinessProcessId < ActiveRecord::Migration[5.2]
  def change
    rename_column :policy_business_processes, :business_processes_id, :business_process_id
  end
end
