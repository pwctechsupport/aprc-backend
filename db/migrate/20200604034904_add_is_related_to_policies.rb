class AddIsRelatedToPolicies < ActiveRecord::Migration[5.2]
  def change
    add_column :policies, :is_related, :boolean, :default => false
  end
end
