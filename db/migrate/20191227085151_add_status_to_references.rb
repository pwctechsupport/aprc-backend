class AddStatusToReferences < ActiveRecord::Migration[5.2]
  def change
    add_column :references, :status, :string
  end
end
