class AddDescriptionToControls < ActiveRecord::Migration[5.2]
  def change
    add_column :controls, :description, :text
  end
end
