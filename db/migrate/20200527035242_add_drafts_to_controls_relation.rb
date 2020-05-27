class AddDraftsToControlsRelation < ActiveRecord::Migration[5.2]
  def change
    add_column :control_risks, :draft_id, :integer
    add_column :control_risks, :published_at, :timestamp
    add_column :control_risks, :trashed_at, :timestamp
    add_column :control_business_processes, :draft_id, :integer
    add_column :control_business_processes, :published_at, :timestamp
    add_column :control_business_processes, :trashed_at, :timestamp
    add_column :resource_controls, :draft_id, :integer
    add_column :resource_controls, :published_at, :timestamp
    add_column :resource_controls, :trashed_at, :timestamp
  end
end
