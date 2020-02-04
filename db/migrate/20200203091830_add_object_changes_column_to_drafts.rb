class AddObjectChangesColumnToDrafts < ActiveRecord::Migration[4.2]
  def self.up
    add_column :drafts, :object_changes, :text
  end

  def self.down
    remove_column :drafts, :object_changes
  end
end
