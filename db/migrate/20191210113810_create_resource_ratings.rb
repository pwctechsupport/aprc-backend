class CreateResourceRatings < ActiveRecord::Migration[5.2]
  def change
    create_table :resource_ratings do |t|
      t.references :resource, foreign_key: true
      t.float :rating
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
