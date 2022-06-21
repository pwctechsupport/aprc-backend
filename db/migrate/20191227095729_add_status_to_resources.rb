class AddStatusToResources < ActiveRecord::Migration[5.2]
  def change
    add_column :resources, :status, :string
  end
end
