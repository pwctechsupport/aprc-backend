class AddIsAttributesToPolicies < ActiveRecord::Migration[5.2]
  def change
    add_column :policies, :is_attributes, :boolean
  end
end
