class CreateTags < ActiveRecord::Migration[5.2]
  def change
    create_table :tags do |t|
      t.integer :x_coordinates
      t.integer :y_coordinates
      t.text :body
      t.references :resource, foreign_key: true
      t.references :business_process, foreign_key: true
      t.string :image_name
      
      t.timestamps
    end
  end
end
