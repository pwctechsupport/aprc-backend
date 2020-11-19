class ChangeTypeCoordinatesAtTags < ActiveRecord::Migration[5.2]
  def change
  	change_column :tags, :x_coordinates, :float
  	change_column :tags, :y_coordinates, :float
  end
end
