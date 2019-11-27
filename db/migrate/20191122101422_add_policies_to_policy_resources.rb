class AddPoliciesToPolicyResources < ActiveRecord::Migration[5.2]
  def change
    add_reference :policy_resources, :policies, foreign_key: true
  end
end
