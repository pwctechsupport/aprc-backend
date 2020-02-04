class CreateUserPolicyCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :user_policy_categories do |t|
      t.integer :user_id
      t.integer :policy_category_id

      t.timestamps
    end
  end
end
