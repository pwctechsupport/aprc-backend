class AddNameToBookmarkPolicies < ActiveRecord::Migration[5.2]
  def change
    add_column :bookmark_policies, :name, :string
  end
end
