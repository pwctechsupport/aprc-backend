class ChangePolicyIdToBeResourceIdInUserResourceVisits < ActiveRecord::Migration[5.2]
  def change
    rename_column :user_resource_visits, :policy_id, :resource_id
  end
end
