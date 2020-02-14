class AddDraftsToRisks < ActiveRecord::Migration[5.2]
  def change
    add_column :risks, :draft_id, :integer
    add_column :risks, :published_at, :timestamp
    add_column :risks, :trashed_at, :timestamp
  end
end
