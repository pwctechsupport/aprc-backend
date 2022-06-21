class AddResourcesToPolicyResources < ActiveRecord::Migration[5.2]
  def change
    add_reference :policy_resources, :resources, foreign_key: true
  end
end
