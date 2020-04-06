class RemoveLastUpdatedOnFromPolicies < ActiveRecord::Migration[5.2]
  def change
    remove_column :policies, :last_updated_on, :string
    remove_column :policies, :created_on, :string
  end
end
