class AddDraftsToPolicyBusinessProcesses < ActiveRecord::Migration[5.2]
  def change
    add_column :policy_business_processes, :draft_id, :integer
    add_column :policy_business_processes, :published_at, :timestamp
    add_column :policy_business_processes, :trashed_at, :timestamp
    add_column :policy_risks, :draft_id, :integer
    add_column :policy_risks, :published_at, :timestamp
    add_column :policy_risks, :trashed_at, :timestamp
    add_column :policy_controls, :draft_id, :integer
    add_column :policy_controls, :published_at, :timestamp
    add_column :policy_controls, :trashed_at, :timestamp
    add_column :policy_resources, :draft_id, :integer
    add_column :policy_resources, :published_at, :timestamp
    add_column :policy_resources, :trashed_at, :timestamp
  end
end
