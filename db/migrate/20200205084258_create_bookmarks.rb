class CreateBookmarks < ActiveRecord::Migration[5.2]
  def change
    create_table :bookmarks do |t|
      t.references :user, foreign_key: true
      t.string :originator_type
      t.integer :originator_id
      t.string :name

      t.timestamps
    end
  end
end
