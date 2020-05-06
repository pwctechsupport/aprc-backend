class AddTrueVersionToPolicies < ActiveRecord::Migration[5.2]
  def change
    add_column :policies, :true_version, :float, :default => 0
  end
end
