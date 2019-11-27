class CreatePolicyBusinessProcesses < ActiveRecord::Migration[5.2]
  def change
    create_table :policy_business_processes do |t|

      t.timestamps
    end
  end
end
