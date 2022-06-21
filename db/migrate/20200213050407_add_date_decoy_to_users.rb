class AddDateDecoyToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :date_decoy, :string
  end
end
