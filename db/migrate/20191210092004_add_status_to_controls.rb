class AddStatusToControls < ActiveRecord::Migration[5.2]
  def change
    add_column :controls, :status, :text
  end
end
