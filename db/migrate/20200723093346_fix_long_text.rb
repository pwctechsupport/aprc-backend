class FixLongText < ActiveRecord::Migration[5.2]
  def change
    change_column :drafts, :object, :text, :limit => 4294967295
    change_column :drafts, :object_changes, :text, :limit => 4294967295
    change_column :policies, :description, :text, :limit => 4294967295

  end
end
