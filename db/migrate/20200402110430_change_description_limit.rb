class ChangeDescriptionLimit < ActiveRecord::Migration[5.2]
  def change
    change_column :policies, :description, :text, :limit => 500000
  end
end
