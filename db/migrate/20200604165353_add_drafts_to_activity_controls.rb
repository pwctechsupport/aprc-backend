class AddDraftsToActivityControls < ActiveRecord::Migration[5.2]
  def change
    add_column :activity_controls, :draft_id, :integer
    add_column :activity_controls, :published_at, :timestamp
    add_column :activity_controls, :trashed_at, :timestamp
  end
end
