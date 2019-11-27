class CreatePolicyResources < ActiveRecord::Migration[5.2]
  def change
    create_table :policy_resources do |t|

      t.timestamps
    end
  end
end
