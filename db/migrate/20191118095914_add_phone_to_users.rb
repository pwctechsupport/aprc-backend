class AddPhoneToUsers < ActiveRecord::Migration[5.2]
  def change
    unless column_exists? :users, :phone
      add_column :users, :phone, :string
    end
  end
end
