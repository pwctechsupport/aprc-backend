class AddStatusToPolicies < ActiveRecord::Migration[5.2]
  def change
    add_column :policies, :status, :text
  end
end
