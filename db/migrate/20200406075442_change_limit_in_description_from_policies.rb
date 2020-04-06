class ChangeLimitInDescriptionFromPolicies < ActiveRecord::Migration[5.2]
  def change
    change_column :policies, :description, :text, :limit => 4294967295
  end
end
