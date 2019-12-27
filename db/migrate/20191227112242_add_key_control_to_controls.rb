class AddKeyControlToControls < ActiveRecord::Migration[5.2]
  def change
    add_column :controls, :key_control, :boolean, null: false, default: false
  end
end