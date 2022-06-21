class AddCreationToPolicies < ActiveRecord::Migration[5.2]
  def change
    add_column :policies, :created_by, :string
    add_column :policies, :created_on, :string
    add_column :policies, :last_updated_by, :string
    add_column :policies, :last_updated_on, :string
  end
end
