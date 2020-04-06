class AddCreateToPolicies < ActiveRecord::Migration[5.2]
  def change
    add_column :controls, :created_by, :string
    add_column :controls, :last_updated_by, :string
    add_column :risks, :created_by, :string
    add_column :risks, :last_updated_by, :string
    add_column :policy_categories, :created_by, :string
    add_column :policy_categories, :last_updated_by, :string
    add_column :references, :created_by, :string
    add_column :references, :last_updated_by, :string
    add_column :resources, :last_updated_by, :string
    add_column :resources, :created_by, :string
    add_column :business_processes, :created_by, :string
    add_column :business_processes, :last_updated_by, :string

  end
end
