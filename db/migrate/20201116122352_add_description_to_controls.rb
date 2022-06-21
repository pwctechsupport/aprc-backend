class AddDescriptionToControls < ActiveRecord::Migration[5.2]
  def change
    add_column :controls, :description, :string
  end
end
