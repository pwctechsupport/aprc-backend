class AddPoliciesToPolicyBusinessProcesses < ActiveRecord::Migration[5.2]
  def change
    add_reference :policy_business_processes, :policies, foreign_key: true
  end
end
