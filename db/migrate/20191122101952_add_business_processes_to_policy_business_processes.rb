class AddBusinessProcessesToPolicyBusinessProcesses < ActiveRecord::Migration[5.2]
  def change
    add_reference :policy_business_processes, :business_processes, foreign_key: true
  end
end
