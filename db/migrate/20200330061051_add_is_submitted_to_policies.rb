class AddIsSubmittedToPolicies < ActiveRecord::Migration[5.2]
  def change
    add_column :policies, :is_submitted, :boolean
  end
end
