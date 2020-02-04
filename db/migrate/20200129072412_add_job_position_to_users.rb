class AddJobPositionToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :job_position, :string
  end
end
