class ChangeLimitInDesciptionPolicies < ActiveRecord::Migration[5.2]
  def change
    change_column :policies, :description, :text, limit: 16.megabytes - 1
  end
end
