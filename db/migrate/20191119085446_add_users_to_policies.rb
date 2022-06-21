class AddUsersToPolicies < ActiveRecord::Migration[5.2]
  def change
    add_reference :policies, :users, foreign_key: true
  end
end
