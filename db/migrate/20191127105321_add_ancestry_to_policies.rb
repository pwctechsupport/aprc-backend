class AddAncestryToPolicies < ActiveRecord::Migration[5.2]
  def change
    add_column :policies, :ancestry, :string
    add_index :policies, :ancestry
  end
end
