class AddPolicyCategoryToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :policy_category, :string
  end
end
