class CreateUserPolicyVisits < ActiveRecord::Migration[5.2]
  def change
    create_table :user_policy_visits do |t|
      t.integer :user_id
      t.integer :policy_id
      t.datetime :recent_visit

      t.timestamps
    end
  end
end
